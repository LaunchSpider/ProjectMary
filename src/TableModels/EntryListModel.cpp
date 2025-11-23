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
    case IdRole:
        return e.id.toString(QUuid::WithoutBraces);
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
    roles[IdRole]          = "id";
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

int EntryListModel::findIndexById(const QUuid &id) const
{
    for (int i = 0; i < m_allEntries.size(); ++i) {
        if (m_allEntries[i].id == id)
            return i;
    }
    return -1;
}

Entry* EntryListModel::findEntryById(const QUuid &id)
{
    for (Entry &e : m_allEntries) {
        if (e.id == id)
            return &e;
    }
    return nullptr;
}

void EntryListModel::notifyEntryChanged(const QUuid &id)
{
    // Find the entry in the filtered list
    for (int i = 0; i < m_entries.size(); ++i) {
        if (m_entries[i].id == id) {
            // Also update in m_allEntries
            for (Entry &e : m_allEntries) {
                if (e.id == id) {
                    m_entries[i] = e;
                    break;
                }
            }

            QModelIndex modelIndex = index(i);
            emit dataChanged(modelIndex, modelIndex);
            return;
        }
    }
}

void EntryListModel::removeEntryById(const QUuid &id)
{
    int idx = findIndexById(id);
    if (idx < 0)
        return;

    // Remove from m_allEntries
    m_allEntries.erase(m_allEntries.begin() + idx);

    // Rebuild filtered list
    setFilter(m_filter);
}
