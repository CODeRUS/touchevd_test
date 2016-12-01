#ifndef EVDEVINPUT_H
#define EVDEVINPUT_H

#include <QObject>

class EvdevInput : public QObject
{
    Q_OBJECT
public:
    explicit EvdevInput(QObject *parent = 0);

signals:
    void touchUpdate(const QVariantList & points);

    void touchPressed(const QVariantList &points);
    void touchMoved(const QVariantList &points);
    void touchReleased();

};

#endif // EVDEVINPUT_H
