#include "ChatDatabase.h"
#include <QStandardPaths>
#include <QDir>
#include <QCoreApplication>
#include <QRandomGenerator>

ChatDatabase::ChatDatabase(QObject *parent) : QObject(parent) {
    QString dbPath = QCoreApplication::applicationDirPath() + "/history.db";
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbPath);

    if (!db.open()) {
        qWarning() << "Failed to open database:" << db.lastError().text();
    }
}

int ChatDatabase::getLastChatId() {
    QSqlQuery query(db);
    if (query.exec("SELECT name FROM sqlite_master WHERE type='table' AND name GLOB '[0-9]*' ORDER BY CAST(name AS INTEGER) DESC LIMIT 1")) {
        if (query.next()) {
            return query.value(0).toInt();
        }
    }
    return 0;
}

int ChatDatabase::createNewChat() {
    int newChatId = getLastChatId() + 1;
    QSqlQuery query(db);
    QString tableName = QString::number(newChatId);

    if (!query.exec(QString("CREATE TABLE IF NOT EXISTS \"%1\" (id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, message TEXT)").arg(tableName))) {
        qWarning() << "Failed to create table:" << query.lastError().text();
        return -1;
    }

    return newChatId;
}

void ChatDatabase::saveMessage(int chatId, const QString &user, const QString &message) {
    QSqlQuery query(db);
    QString tableName = QString::number(chatId);

    query.prepare(QString("INSERT INTO \"%1\" (user, message) VALUES (:user, :message)").arg(tableName));
    query.bindValue(":user", user);
    query.bindValue(":message", message);

    if (!query.exec()) {
        qWarning() << "Failed to insert message:" << query.lastError().text();
    }
}

QVector<QString> ChatDatabase::getRandomFirstMessages() {
    QVector<QString> messages;
    QSqlQuery query(db);

    if (!query.exec("SELECT name FROM sqlite_master WHERE type='table' AND name GLOB '[0-9]*' ORDER BY RANDOM() LIMIT 4")) {
        qWarning() << "Failed to fetch table names:" << query.lastError().text();
        return messages;
    }

    while (query.next()) {
        QString tableName = query.value(0).toString();
        QSqlQuery msgQuery(db);
        QString msgQueryStr = QString("SELECT message FROM \"%1\" ORDER BY id ASC LIMIT 1").arg(tableName);

        if (msgQuery.exec(msgQueryStr) && msgQuery.next()) {
            messages.append(msgQuery.value(0).toString());
        }
    }

    return messages;
}
