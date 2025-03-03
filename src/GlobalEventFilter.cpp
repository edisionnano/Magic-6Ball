#include "GlobalEventFilter.h"
#include <QDebug>

GlobalEventFilter::GlobalEventFilter(QObject *parent)
    : QObject(parent) {}

bool GlobalEventFilter::eventFilter(QObject *obj, QEvent *event) {
    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
        if (keyEvent->modifiers() & Qt::ControlModifier &&
            keyEvent->modifiers() & Qt::AltModifier &&
            keyEvent->nativeScanCode() == 0x18) {  // Q
            QCoreApplication::exit(42); // Our custom quit exit code
            return true;
        }
    }
    return QObject::eventFilter(obj, event);
}
