#include "evdevinput.h"
#include "uinputevpoll.h"

#include <QThread>

EvdevInput::EvdevInput(QObject *parent) :
    QObject(parent)
{
    QThread *evthread = new QThread(this);

    UinputEvPoll *evpoll = new UinputEvPoll();
    evpoll->moveToThread(evthread);
    QObject::connect(evpoll, SIGNAL(update(int,QVariantMap)), this, SIGNAL(touchUpdate(int,QVariantMap)));
    QObject::connect(evpoll, SIGNAL(pressed(QVariantList)), this, SIGNAL(touchPressed(QVariantList)));
    QObject::connect(evpoll, SIGNAL(moved(QVariantList)), this, SIGNAL(touchMoved(QVariantList)));
    QObject::connect(evpoll, SIGNAL(released()), this, SIGNAL(touchReleased()));
    QObject::connect(evpoll, SIGNAL(pollingRequested()), evthread, SLOT(start()));
    QObject::connect(evthread, SIGNAL(started()), evpoll, SLOT(doPoll()));
    QObject::connect(evpoll, SIGNAL(finished()), evthread, SLOT(quit()), Qt::DirectConnection);

    evpoll->findDevice();
}
