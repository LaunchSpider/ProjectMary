// include/EntryStorage/Entry.hpp
#pragma once

#include <QDateTime>
#include <QString>
#include <QUuid>

struct Entry
{
    enum class State {
        NotStarted,
        InProgress,
        Completed
    };

    Entry() : id(QUuid::createUuid()) {}

    // Constructor that accepts an existing ID (for loading from file)
    Entry(const QUuid &existingId) : id(existingId) {}

    QUuid     id;
    QString   entryName;
    QString   description;
    QDateTime deadline;
    State     state = State::NotStarted;
};
