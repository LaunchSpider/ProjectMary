#pragma once

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
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

private:
    EntryListModel m_model;
};
