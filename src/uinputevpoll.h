#ifndef UINPUTEVPOLL_H
#define UINPUTEVPOLL_H

#include <QObject>
#include <QMutex>
#include <QVariantMap>

class UinputEvPoll : public QObject
{
    Q_OBJECT
public:
    explicit UinputEvPoll(QObject *parent = 0);
    virtual ~UinputEvPoll();

    void requestPolling(int fd);
    void abort();

signals:
    void pollingRequested();
    void finished();

    void pressed(const QVariantList &points);
    void moved(const QVariantList &points);
    void released();

    void update(int index, const QVariantMap & parameters);

public slots:
    void findDevice();
    void doPoll();

private:
    bool _polling;
    bool _abort;
    int _uinputfd;

    QMutex mutex;

    int version;
    int current_index;
    QVariantList touch_points;
    timeval last_moved;
    int moved_interval;

    void readEvent(int fd);
    int device_filter(int fd, char *name);

};

#endif // UINPUTEVPOLL_H
