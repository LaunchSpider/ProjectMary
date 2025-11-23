#pragma once

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QUuid>
#include "EntryListModel.hpp"
#include "Entry.hpp"

class Controller : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(EntryListModel* entryModel READ entryModel CONSTANT)

public:
    explicit Controller(QObject *parent = nullptr);

    static Controller *create(QQmlEngine *engine, QJSEngine *jsEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(jsEngine)
        return new Controller();
    }

    EntryListModel *entryModel() { return &m_model; }

    Q_INVOKABLE void addEntry(const QString &name,
                              const QString &description,
                              const QDateTime &deadline,
                              const QString &statusStr);

    Q_INVOKABLE void updateEntryById(const QString &idStr,
                                     const QString &name,
                                     const QString &description,
                                     const QDateTime &deadline,
                                     const QString &statusStr);

    Q_INVOKABLE void saveEntries(const QString &filename);
    Q_INVOKABLE void loadEntries(const QString &filename);

    Q_INVOKABLE void sortBy(const QString &roleName) { m_model.sortBy(roleName); }

    Q_INVOKABLE void removeEntryById(const QString &idStr) {
        m_model.removeEntryById(QUuid::fromString(idStr));
    }

    Q_INVOKABLE void setSearchFilter(const QString &text) {
        m_model.setFilter(text);
    }

private:
    EntryListModel m_model;
};
