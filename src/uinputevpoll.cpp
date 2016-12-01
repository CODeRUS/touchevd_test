#include "uinputevpoll.h"
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <sys/epoll.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <linux/input.h>

#define DEV_INPUT_DIR	"/dev/input"
#define EVENT_PREFIX	"event"

#define NBITS(x)		((((x) - 1) / __BITS_PER_LONG) + 1)
#define BIT(arr, bit)		((arr[(bit) / __BITS_PER_LONG] >> \
                 ((bit) % __BITS_PER_LONG)) & 1)

UinputEvPoll::UinputEvPoll(QObject *parent) :
    QObject(parent)
{
    _polling = false;
    _abort = false;
    _uinputfd = -1;

    current_index = 0;
}
UinputEvPoll::~UinputEvPoll()
{
    if (_polling) {
        abort();
        close(_uinputfd);
    }
}

void UinputEvPoll::findDevice()
{
    DIR *dir;
    struct dirent *d;
    int fd = -1;

    if (!(dir = opendir(DEV_INPUT_DIR))) {
        printf("Can't open directory %s\n", DEV_INPUT_DIR);
        return;
    }

    while ((d = readdir(dir))) {
        char name[256];

        if (strncmp(d->d_name, EVENT_PREFIX, strlen(EVENT_PREFIX))) {
            continue; /* Not /dev/input/event* file */
        }

        sprintf(name, "%s/%s", DEV_INPUT_DIR, d->d_name);
        fd = open(name, O_RDONLY | O_NONBLOCK);
        if (fd == -1) {
            printf("Can't open input device %s / %d\n", name, fd);
            continue;
        }

        if (device_filter(fd, name) == -1) {
            close(fd);
            continue;
        }
        else {
            printf("Processing input events file %s\n", name);
            break;
        }
    }

    closedir(dir);
    if (fd != -1) {
        requestPolling(fd);
    }
    else {
        printf("Can't find suitable input device!\n");
    }
}

void UinputEvPoll::abort()
{
    mutex.lock();
    if (_polling)
    {
        _abort = true;
    }
    mutex.unlock();
}

void UinputEvPoll::requestPolling(int fd)
{
    mutex.lock();
    _polling = true;
    _abort = false;
    _uinputfd = fd;
    mutex.unlock();

    emit pollingRequested();
}

void UinputEvPoll::doPoll()
{
    int epfd;
    int ret;
    int i;
    struct epoll_event ev;
    struct epoll_event evs[32];

    epfd = epoll_create1(0);

    if (epfd < 0)
    {
        printf("failed to create epoll instance\n");

        emit finished();
        return;
    }

    memset(&ev, 0, sizeof(ev));
    ev.events = EPOLLIN;
    ev.data.fd = _uinputfd;

    ret = epoll_ctl(epfd, EPOLL_CTL_ADD, _uinputfd, &ev);
    if (ret)
    {
        printf("Couldn't add to epoll\n");
        close(epfd);

        emit finished();
        return;
    }

    printf("starting touch events polling.\n");

    last_moved.tv_sec = 0;
    last_moved.tv_usec = 0;

    moved_interval = 1000000 / 60; // 60 FPS

    for (;;)
    {
        // Checks if the process should be aborted
        mutex.lock();
        bool abort = _abort;
        mutex.unlock();

        if (abort)
        {
            break;
        }

        ret = epoll_wait(epfd, evs, 32, -1);

        if (ret < 0)
        {
            if (errno == EINTR)
                continue;
            else
                break;
        }

        for (i = 0 ; i<ret ; i++)
        {
            readEvent(evs[i].data.fd);
        }
    }

    close(epfd);

    emit finished();
}

void UinputEvPoll::readEvent(int fd)
{
    ssize_t len;
    struct input_event evs[32];

    while ((len = read(fd, &evs, sizeof(evs))) > 0)
    {
        int state = 2;

        int temp_x = 0;
        int temp_y = 0;
        int temp_w = 0;
        int temp_i = 0;

        bool clean = true;

        QVariantList points;
        points << QVariantMap() << QVariantMap() << QVariantMap() << QVariantMap() << QVariantMap();

        const size_t nevs = len / sizeof(struct input_event);
        size_t i;
        //printf("number of events: %d\n", nevs);
        for (i = 0; i < nevs; i++)
        {
            //printf("type: %d, code: %d, value: %d\n", evs[i].type, evs[i].code, evs[i].value);
            if (version == 3) {
                int value = evs[i].value;
                switch (evs[i].code) {
                case SYN_REPORT:
                    emit update(points);
                    break;
                case ABS_MT_TRACKING_ID: {
                    if (value == -1) {
                        QVariantMap point = points[current_index].toMap();
                        point["released"] = true;
                        point["active"] = true;
                        points[current_index] = point;
                    }
                    break;
                }
                case ABS_MT_SLOT:
                    current_index = value;
                    break;
                case ABS_MT_POSITION_X: {
                    QVariantMap point = points[current_index].toMap();
                    point["pointX"] = value;
                    point["active"] = true;
                    points[current_index] = point;
                    break;
                }
                case ABS_MT_POSITION_Y: {
                    QVariantMap point = points[current_index].toMap();
                    point["pointY"] = value;
                    point["active"] = true;
                    points[current_index] = point;
                    break;
                }
                case ABS_MT_WIDTH_MAJOR: {
                    QVariantMap point = points[current_index].toMap();
                    point["pointWidth"] = value;
                    point["active"] = true;
                    points[current_index] = point;
                    break;
                }
                default:
                    break;
                }
            }
            else if (version == 2) {
                if (evs[i].type == EV_SYN)
                {
                    switch(evs[i].code) {
                        case SYN_REPORT:
                            if (state == 0) {
                                //printf("touch released\n");
                                Q_EMIT released();
                            }
                            else if (state == 1) {
                                //printf("touch press at: %d.%d\n", touch_point.x(), touch_point.y());
                                Q_EMIT pressed(touch_points);
                            }
                            else if (state == 2) {
                                //printf("touch moved to: %d.%d\n", touch_point.x(), touch_point.y());
                                Q_EMIT moved(touch_points);
                            }
                            break;
                        case SYN_MT_REPORT: {
                            if (state == 2) {
                                QVariantMap touch;
                                touch["x"] = temp_x;
                                touch["y"] = temp_y;
                                touch["w"] = temp_w;
                                touch["i"] = temp_i;
                                touch_points.append(touch);
                            }
                            break;
                        }
                        default:
                            break;
                    }
                }
                else if (evs[i].type == EV_KEY && evs[i].code == BTN_TOUCH) {
                    state = evs[i].value;
                    if (state == 1) {
                        touch_points.clear();
                    }
                }
                else if (evs[i].type == EV_ABS) {
                    if (state == -1) {
                        continue;
                    }
                    if ((evs[i].time.tv_sec == last_moved.tv_sec) &&
                            (evs[i].time.tv_usec == last_moved.tv_usec) ||
                        ((evs[i].time.tv_usec - last_moved.tv_usec) > moved_interval) ||
                        ((evs[i].time.tv_sec - last_moved.tv_sec) > 1) ||
                        ((evs[i].time.tv_sec - last_moved.tv_sec) == 1 &&
                            ((1000000 - last_moved.tv_usec + evs[i].time.tv_usec) > moved_interval)) ||
                        ((evs[i].time.tv_usec - last_moved.tv_usec) > moved_interval)) {
                        last_moved = evs[i].time;
                    }
                    else {
                        state = -1;
                        continue;
                    }
                    switch(evs[i].code) {
                        case ABS_MT_POSITION_X:
                            temp_x = evs[i].value;
                            break;
                        case ABS_MT_POSITION_Y:
                            temp_y = evs[i].value;
                            break;
                        case ABS_MT_TOUCH_MAJOR:
                            temp_w = evs[i].value;
                            break;
                        case ABS_MT_TRACKING_ID:
                            temp_i = evs[i].value;
                            break;
                        default:
                            break;
                    }
                }
            }
            else {/*
                if (evs[i].type == EV_ABS) {
                    switch(evs[i].code) {
                        case ABS_MT_POSITION_X:
                            if (temp_x == 0)
                                temp_x = evs[i].value;
                            break;
                        case ABS_MT_POSITION_Y:
                            if (temp_y == 0)
                                temp_y = evs[i].value;
                            break;
                        case ABS_MT_PRESSURE:
                            if (evs[i].value == 1) {
                                printf("Released\n");
                                Q_EMIT released();
                            }
                            break;
                        default:
                            break;
                    }
                }
                else if (evs[i].type == EV_SYN) {
                    switch(evs[i].code) {
                        case SYN_MT_REPORT:
                            if (nevs == 2) {

                            }
                            else if (clean) {
                                printf("Pressed: %d.%d\n", temp_x, temp_y);
                                Q_EMIT pressed(QPoint(temp_x, temp_y));
                                clean = false;
                            }
                            else {
                                printf("Moved: %d.%d\n", temp_x, temp_y);
                                Q_EMIT moved(QPoint(temp_x, temp_y));
                            }
                            break;
                        case SYN_REPORT:
                            temp_x = 0;
                            temp_y = 0;
                            if (nevs == 2) {
                                clean = true;
                            }
                            break;
                        default:
                            break;
                    }
                }*/
            }
        }
    }

    if (len < 0 && errno != EWOULDBLOCK)
    {
        printf("Couldn't read, %s\n", strerror(errno));
        return;
    }
}

int UinputEvPoll::device_filter(int fd, char *name)
{
    unsigned long bits[EV_MAX][NBITS(KEY_MAX)];

    memset(bits, '\0', sizeof(bits));
    if (ioctl(fd, EVIOCGBIT(0, EV_MAX), bits[0]) == -1) {
        printf("ioctl(, EVIOCGBIT(0, ), ) error on event device %s\n",
               name);
        return -1;
    }

    if (BIT(bits[0], EV_ABS)) {
        if (ioctl(fd, EVIOCGBIT(EV_ABS, KEY_MAX), bits[EV_ABS]) == -1)
            printf("ioctl(, EVIOCGBIT(EV_ABS, ), ) error on event\n"
                   " device %s", name);
        else if (BIT(bits[EV_ABS], ABS_MT_POSITION_X) &&
             BIT(bits[EV_ABS], ABS_MT_POSITION_Y)) {
            printf("Device %s supports multi-touch events.\n", name);

            if (BIT(bits[EV_ABS], ABS_MT_SLOT)) {
                version = 3;
                printf("Device %s supports multi-touch slot events.\n", name);
                return 0;
            }

            if (BIT(bits[0], EV_KEY)) {
                if (ioctl(fd, EVIOCGBIT(EV_KEY, KEY_MAX), bits[EV_KEY]) == -1)
                    printf("ioctl(, EVIOCGBIT(EV_ABS, ), ) error on event\n"
                           " device %s", name);
                else if (BIT(bits[EV_KEY], BTN_TOUCH)) {
                    printf("Device %s supports button touch events.\n", name);
                    version = 2;
                }
                else {
                    printf("Device %s not supports button touch events.\n", name);
                    version = 1;
                }
            }

            return 0;
        }
    }

    printf("Skipping unsupported device %s.\n", name);
    return -1;
}
