#include <QGuiApplication>
#include <QQuickView>
#include <QtQml>
#include <sailfishapp.h>
#include <qpa/qplatformnativeinterface.h>
#include <QRegion>

#include "evdevinput.h"

int main(int argc, char *argv[])
{
    QGuiApplication *app = SailfishApp::application(argc, argv);
    QQuickView *view = SailfishApp::createView();

    QColor color;
    color.setRedF(0.0);
    color.setGreenF(0.0);
    color.setBlueF(0.0);
    color.setAlphaF(0.0);
    view->setColor(color);
    view->setClearBeforeRendering(true);

    EvdevInput *ei = new EvdevInput(app);
    view->rootContext()->setContextProperty("evdevInput", ei);

    view->setSource(SailfishApp::pathTo("qml/touchevd_test.qml"));
    view->create();
    QPlatformNativeInterface *native = QGuiApplication::platformNativeInterface();
    native->setWindowProperty(view->handle(), QLatin1String("CATEGORY"), "notification");
    native->setWindowProperty(view->handle(), QLatin1String("MOUSE_REGION"), QRegion(0, 0, 0, 0));

    view->show();
    return app->exec();
}

