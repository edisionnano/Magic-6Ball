#ifndef GLOBALEVENTFILTER_H
#define GLOBALEVENTFILTER_H

#include <QObject>
#include <QKeyEvent>
#include <QCoreApplication>

class GlobalEventFilter : public QObject {
    Q_OBJECT
public:
    explicit GlobalEventFilter(QObject *parent = nullptr);

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
};

#endif // GLOBALEVENTFILTER_H
