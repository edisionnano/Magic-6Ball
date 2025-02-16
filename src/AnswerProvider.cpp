#include "AnswerProvider.h"
#include <QFile>
#include <QTextStream>
#include <QCoreApplication>

AnswerProvider::AnswerProvider(QObject *parent) : QObject(parent) {}

QStringList AnswerProvider::loadAnswers() {
    QString appDir = QCoreApplication::applicationDirPath();
    QString answersPath = appDir + "/answers.txt";
    QString resourcePath = ":/data/answers.txt";

    QFile file(answersPath);
    QStringList answers;

    if (!file.exists()) {
        QFile resourceFile(resourcePath);
        if (resourceFile.exists()) {
            if (resourceFile.copy(answersPath)) {
                QFile::setPermissions(answersPath, QFile::ReadUser | QFile::WriteUser);
            }
        }
    }

    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine().trimmed();
            if (!line.isEmpty()) {
                answers.append(line);
            }
        }
    }

    if (answers.isEmpty()) {
        answers.append("There are no available answers!");
    }

    return answers;
}

void AnswerProvider::addAnswer(const QString &newAnswer) {
    QString appDir = QCoreApplication::applicationDirPath();
    QString answersPath = appDir + "/answers.txt";

    QFile file(answersPath);

    if (file.open(QIODevice::ReadWrite | QIODevice::Text)) {
        QTextStream in(&file);
        QString existingAnswers = in.readAll();
        if (existingAnswers.contains(newAnswer)) {
            qWarning() << "Answer already exists: " << newAnswer;
        } else {
            file.seek(file.size());
            QTextStream out(&file);
            out << newAnswer << "\n";
        }
    } else {
        qWarning() << "Failed to open file for reading and writing: " << answersPath;
    }
}
