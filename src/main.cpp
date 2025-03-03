#include "AnswerProvider.h"
#include "ChatDatabase.h"
#include "GlobalEventFilter.h"
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

    // This hides the cursor
    // app.setOverrideCursor(Qt::BlankCursor);

    engine.load(QUrl(QStringLiteral("qrc:/magic6ball/qml/Main.qml")));

    GlobalEventFilter globalFilter;
    app.installEventFilter(&globalFilter);

    return app.exec();
}
