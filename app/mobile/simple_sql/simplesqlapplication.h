#ifndef SIMPLESQLAPPLICATION_H
#define SIMPLESQLAPPLICATION_H

#include <QObject>

#include <QMap>
#include <QVariant>

#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>

class SimpleSqlDbManager;
class QQmlApplicationEngine;

class SimpleSqlApplication : public QObject
{
    Q_OBJECT

    SimpleSqlDbManager *m_db_manager;
    QQmlApplicationEngine *m_engine;

    QNetworkAccessManager m_nam;

    struct BasicRequest
    {
        QString title;
        QString sql;
    };

    QList <BasicRequest> m_basic_requests;

    QMap <QString, QVariant> m_storage;

//    QString m_server_host = "http://mtlsoft.ru";
//    QString m_server_path = "/simplesql/query.php";

//    QString m_server_host = "simple_sql.local";
//    QString m_server_path = "";

    QString m_server_host = "";
    QString m_server_path = "";
    int m_server_port = 80;

    QMap <QNetworkReply*, QString> m_reply_to_requests;

    QUrl createUrl();
    QString getNetworkErrorString(QNetworkReply::NetworkError error);


public:
    explicit SimpleSqlApplication(QObject *parent = 0);

    bool init();

signals:
    void back();

    void requestFinished(QString, QString);

public slots:
    void getRequest(QString, QVariant data = QVariant());

    void goBack();

    void setToStorage(QString key, QString storage);
    QVariant getFromStorage(QString storage);

    bool settingsNeed() const;

    void setSettings(QString server_host, QString server_path, QString server_port);

private slots:
    void slotFinished();
};

#endif // SIMPLESQLAPPLICATION_H
