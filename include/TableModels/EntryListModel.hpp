#pragma once

#include <QAbstractListModel>
#include <QtQml/qqmlregistration.h>
#include "Entry.hpp"
#include "EntryVector.hpp"

class EntryListModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        DescriptionRole,
        DeadlineRole,
        StatusRole
    };
    Q_ENUM(Roles)

    explicit EntryListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int,QByteArray> roleNames() const override;

    Q_INVOKABLE int rowCountQml() const { return rowCount(); }

    Q_INVOKABLE void sortBy(const QString &roleName);

    Q_INVOKABLE QVariantMap get(int row) const {
        QVariantMap m;
        if (row < 0 || row >= m_entries.size())
            return m;

        const Entry &e = m_entries[row];
        m["name"] = e.entryName;
        m["description"] = e.description;
        m["deadline"] = e.deadline;

        QString status;
        switch (e.state) {
        case Entry::State::NotStarted: status = "Not started"; break;
        case Entry::State::InProgress: status = "In progress"; break;
        case Entry::State::Completed: status = "Completed"; break;
        }
        m["status"] = status;

        return m;
    }

    void addEntry(const Entry &entry);
    Entry &entryAt(int row) { return m_entries[row]; }

private:
    EntryVector m_entries;
    bool m_sortAscending = true;
};
