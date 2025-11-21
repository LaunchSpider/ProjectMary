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
    m_model.sortByDeadline();
}

void Controller::updateEntry(int index,
                             const QString &name,
                             const QString &description,
                             const QDateTime &deadline,
                             const QString &statusStr)
{
    if (index < 0 || index >= m_model.rowCount())
        return;

    Entry &e = m_model.entryAt(index);
    e.entryName = name;
    e.description = description;
    e.deadline = deadline;

    if (statusStr == "In progress")
        e.state = Entry::State::InProgress;
    else if (statusStr == "Completed")
        e.state = Entry::State::Completed;
    else
        e.state = Entry::State::NotStarted;

    QModelIndex modelIndex = m_model.index(index);
    m_model.dataChanged(modelIndex, modelIndex);

    m_model.sortByDeadline();
}

void Controller::saveEntries(const QString &filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    // Write header
    out << "Name,Description,Deadline,Status\n";

    for (int i = 0; i < m_model.rowCount(); ++i) {
        const Entry &e = m_model.entryAt(i);
        QString statusStr;
        switch (e.state) {
        case Entry::State::NotStarted: statusStr = "Not started"; break;
        case Entry::State::InProgress: statusStr = "In progress"; break;
        case Entry::State::Completed:  statusStr = "Completed"; break;
        }
        out << e.entryName << ","
            << e.description << ","
            << e.deadline.toString() << ","
            << statusStr << "\n";
    }
    file.close();
}

void Controller::loadEntries(const QString &filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    QTextStream in(&file);
    QString line = in.readLine(); // Skip header
    while (!in.atEnd()) {
        line = in.readLine();
        QStringList fields = line.split(',');
        if (fields.size() != 4)
            continue;

        Entry e;
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

        m_model.addEntry(e);
    }
    file.close();
    m_model.sortByDeadline();
}

