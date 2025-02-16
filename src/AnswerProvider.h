#ifndef ANSWERPROVIDER_H
#define ANSWERPROVIDER_H

#include <QObject>
#include <QStringList>

class AnswerProvider : public QObject {
    Q_OBJECT
public:
    explicit AnswerProvider(QObject *parent = nullptr);
    Q_INVOKABLE QStringList loadAnswers();
    Q_INVOKABLE void addAnswer(const QString &newAnswer);
};

#endif // ANSWERPROVIDER_H
