TARGET = touchevd_test
target.path = /usr/bin

QT += gui-private
CONFIG += sailfishapp

SOURCES += src/touchevd_test.cpp \
    src/uinputevpoll.cpp \
    src/evdevinput.cpp

HEADERS += \
    src/uinputevpoll.h \
    src/evdevinput.h

qml.files = qml
qml.path = /usr/share/touchevd_test

INSTALLS = target qml

OTHER_FILES += qml/touchevd_test.qml \
    rpm/touchevd_test.spec

