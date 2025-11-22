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
    m_allEntries.push_back(entry);
    setFilter(m_filter); // rebuilds m_entries
}

void EntryListModel::setFilter(const QString &filterText)
{
    beginResetModel();
    m_filter = filterText.trimmed();

    m_entries.clear();

    if (m_filter.isEmpty()) {
        m_entries = m_allEntries;
    } else {
        for (const Entry &e : m_allEntries) {
            if (e.entryName.contains(m_filter, Qt::CaseInsensitive))
                m_entries.push_back(e);
        }
    }

    endResetModel();
}

void EntryListModel::sortBy(const QString &roleName)
{
    if (roleName == "name") {
        std::sort(m_allEntries.begin(), m_allEntries.end(),
                  [&](const Entry &a, const Entry &b){
                      return m_sortAscending ? a.entryName < b.entryName
                                             : a.entryName > b.entryName;
                  });
    }
    else if (roleName == "deadline") {
        std::sort(m_allEntries.begin(), m_allEntries.end(),
                  [&](const Entry &a, const Entry &b){
                      return m_sortAscending ? a.deadline < b.deadline
                                             : a.deadline > b.deadline;
                  });
    }
    else if (roleName == "status") {
        std::sort(m_allEntries.begin(), m_allEntries.end(),
                  [&](const Entry &a, const Entry &b){
                      return m_sortAscending ? a.state < b.state
                                             : a.state > b.state;
                  });
    }

    m_sortAscending = !m_sortAscending;

    // recreate filtered list
    setFilter(m_filter);
}

void EntryListModel::removeEntry(int index) {
    if (index < 0 || index >= m_entries.size())
        return;
    beginRemoveRows(QModelIndex(), index, index);
    m_entries.erase(m_entries.begin() + index);
    endRemoveRows();
}


