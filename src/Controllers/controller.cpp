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
}
