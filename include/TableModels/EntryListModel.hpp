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

    Q_INVOKABLE void sortByDeadline();
    Q_INVOKABLE void toggleSortOrder();
    Q_INVOKABLE bool sortAscending() const { return m_sortAscending; }

    void addEntry(const Entry &entry);

    Entry &entryAt(int row) { return m_entries[row]; }

private:
    EntryVector m_entries;

    bool m_sortAscending = true;
};
