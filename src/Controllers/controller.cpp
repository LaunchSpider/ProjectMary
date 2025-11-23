#include <QFile>
#include <QTextStream>
#include <QDir>

#include "Controller.hpp"

Controller::Controller(QObject *parent)
    : QObject(parent)
{
}

void Controller::addEntry(const QString &name,
                          const QString &description,
                          const QDateTime &deadline,
                          const QString &statusStr)
{
    Entry e;
    e.entryName   = name;
    e.description = description;
    e.deadline    = deadline;

    if (statusStr == QStringLiteral("In progress"))
        e.state = Entry::State::InProgress;
    else if (statusStr == QStringLiteral("Completed"))
        e.state = Entry::State::Completed;
    else
        e.state = Entry::State::NotStarted;

    m_model.addEntry(e);
}

void Controller::updateEntryById(const QString &idStr,
                                 const QString &name,
                                 const QString &description,
                                 const QDateTime &deadline,
                                 const QString &statusStr)
{
    QUuid id = QUuid::fromString(idStr);
    Entry *e = m_model.findEntryById(id);

    if (!e)
        return;

    e->entryName = name;
    e->description = description;
    e->deadline = deadline;

    if (statusStr == "In progress")
        e->state = Entry::State::InProgress;
    else if (statusStr == "Completed")
        e->state = Entry::State::Completed;
    else
        e->state = Entry::State::NotStarted;

    m_model.notifyEntryChanged(id);
}

void Controller::saveEntries(const QString &filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    out << "ID,Name,Description,Deadline,Status\n";

    const EntryVector &all = m_model.allEntries();
    for (const Entry &e : all) {
        QString statusStr;
        switch (e.state) {
        case Entry::State::NotStarted: statusStr = "Not started"; break;
        case Entry::State::InProgress: statusStr = "In progress"; break;
        case Entry::State::Completed:  statusStr = "Completed"; break;
        }
        out << e.id.toString(QUuid::WithoutBraces) << ","
            << e.entryName << ","
            << e.description << ","
            << e.deadline.toString() << ","
            << statusStr << "\n";
    }
}


void Controller::loadEntries(const QString &filename)
{
    EntryVector entries;

    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream in(&file);
    QString header = in.readLine();

    // Check if this is an old format file (without ID column)
    bool hasIdColumn = header.startsWith("ID,");

    while (!in.atEnd()) {
        QString line = in.readLine();
        QStringList fields = line.split(',');

        Entry e;

        if (hasIdColumn && fields.size() >= 5) {
            // New format with ID
            e = Entry(QUuid::fromString(fields[0]));
            e.entryName = fields[1];
            e.description = fields[2];
            e.deadline = QDateTime::fromString(fields[3]);
            QString statusStr = fields[4];

            if (statusStr == "In progress")
                e.state = Entry::State::InProgress;
            else if (statusStr == "Completed")
                e.state = Entry::State::Completed;
            else
                e.state = Entry::State::NotStarted;
        }
        else if (!hasIdColumn && fields.size() >= 4) {
            // Old format without ID - generate new ID
            e.entryName = fields[0];
            e.description = fields[1];
            e.deadline = QDateTime::fromString(fields[2]);
            QString statusStr = fields[3];

            if (statusStr == "In progress")
                e.state = Entry::State::InProgress;
            else if (statusStr == "Completed")
                e.state = Entry::State::Completed;
            else
                e.state = Entry::State::NotStarted;
        }
        else {
            continue; // Skip malformed lines
        }

        entries.push_back(e);
    }

    m_model.setAllEntries(entries);
}
