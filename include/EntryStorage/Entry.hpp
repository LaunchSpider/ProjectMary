// include/EntryStorage/Entry.hpp
#pragma once

#include <QDateTime>
#include <QString>

struct Entry
{
    enum class State {
        NotStarted,
        InProgress,
        Completed
    };

    Entry() = default;

    QString   entryName;
    QString   description;
    QDateTime deadline;
    State     state = State::NotStarted;
};
