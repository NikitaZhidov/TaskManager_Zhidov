#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QApplication>
#include <QQuickWidget>
#include <QSystemTrayIcon>
#include <QIcon>


#include "helper.h"

// Объявляем пользовательский тип данных для работы с иконкой в QML
Q_DECLARE_METATYPE(QSystemTrayIcon::ActivationReason)

int main(int argc, char *argv[])
{  
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // Регистрируем QSystemTrayIcon в качестве типа объекта в Qml
    qmlRegisterType<QSystemTrayIcon>("QSystemTrayIcon", 1, 0, "QSystemTrayIcon");

    // Регистрируем в QML тип данных для работы с получаемыми данными при клике по иконке
    qRegisterMetaType<QSystemTrayIcon::ActivationReason>("ActivationReason");

    Helper helper;
    // Устанавливаем Иконку в контекст движка
    engine.rootContext()->setContextProperty("iconTray", QIcon(":/qml/Img/task_manager.ico"));
    engine.rootContext()->setContextProperty("helper", &helper);
    engine.load(url);

    return app.exec();
}
