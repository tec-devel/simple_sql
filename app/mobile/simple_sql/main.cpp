#include <QGuiApplication>

#include "simplesqlapplication.h"


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    SimpleSqlApplication simple_sql_app;
    simple_sql_app.init();

    return app.exec();
}
