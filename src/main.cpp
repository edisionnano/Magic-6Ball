#include "AnswerProvider.h"
#include "ChatDatabase.h"
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QObject>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    AnswerProvider answerProvider;
    engine.rootContext()->setContextProperty("answerProvider", &answerProvider);

    ChatDatabase chatDb;
    engine.rootContext()->setContextProperty("chatDb", &chatDb);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("magic6ball", "Main");

    return app.exec();
}
