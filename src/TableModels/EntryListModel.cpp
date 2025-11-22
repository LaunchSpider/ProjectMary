#include "EntryListModel.hpp"

#include <algorithm>

EntryListModel::EntryListModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int EntryListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_entries.size();
}

QVariant EntryListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return {};

    const Entry &e = m_entries.at(index.row());

    switch (role) {
    case NameRole:
        return e.entryName;
    case DescriptionRole:
        return e.description;
    case DeadlineRole:
        return e.deadline;
    case StatusRole:
        switch (e.state) {
        case Entry::State::NotStarted: return QStringLiteral("Not started");
        case Entry::State::InProgress: return QStringLiteral("In progress");
        case Entry::State::Completed:  return QStringLiteral("Completed");
        }
    default:
        return {};
    }
}

QHash<int,QByteArray> EntryListModel::roleNames() const
{
    QHash<int,QByteArray> roles;
    roles[NameRole]        = "name";
    roles[DescriptionRole] = "description";
    roles[DeadlineRole]    = "deadline";
    roles[StatusRole]      = "status";
    return roles;
}

void EntryListModel::addEntry(const Entry &entry)
{
    const int newRow = rowCount();
    beginInsertRows(QModelIndex(), newRow, newRow);
    m_entries.push_back(entry);
    endInsertRows();
}

void EntryListModel::sortBy(const QString &roleName)
{
    beginResetModel();
    if (roleName == "name") {
        if (m_sortAscending)
            std::sort(m_entries.begin(), m_entries.end(), [](const Entry &a, const Entry &b){ return a.entryName < b.entryName; });
        else
            std::sort(m_entries.begin(), m_entries.end(), [](const Entry &a, const Entry &b){ return a.entryName > b.entryName; });
    } else if (roleName == "deadline") {
        if (m_sortAscending)
            std::sort(m_entries.begin(), m_entries.end(), [](const Entry &a, const Entry &b){ return a.deadline < b.deadline; });
        else
            std::sort(m_entries.begin(), m_entries.end(), [](const Entry &a, const Entry &b){ return a.deadline > b.deadline; });
    } else if (roleName == "status") {
        if (m_sortAscending)
            std::sort(m_entries.begin(), m_entries.end(), [](const Entry &a, const Entry &b){ return a.state < b.state; });
        else
            std::sort(m_entries.begin(), m_entries.end(), [](const Entry &a, const Entry &b){ return a.state > b.state; });
    }
    // flip order for next sort unless it's a repeated header click
    m_sortAscending = !m_sortAscending;
    endResetModel();
}

