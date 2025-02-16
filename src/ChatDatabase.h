#ifndef CHATDATABASE_H
#define CHATDATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

class ChatDatabase : public QObject {
    Q_OBJECT
public:
    explicit ChatDatabase(QObject *parent = nullptr);
    Q_INVOKABLE int createNewChat();
    Q_INVOKABLE void saveMessage(int chatId, const QString &user, const QString &message);
    Q_INVOKABLE QVector<QString> getRandomFirstMessages();

private:
    QSqlDatabase db;
    int getLastChatId();
};

#endif // CHATDATABASE_H
