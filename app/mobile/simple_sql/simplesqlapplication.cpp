#include "simplesqlapplication.h"

#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <QFile>
#include <QDomDocument>

#include <QUrlQuery>
#include <QJsonDocument>

#include <QStandardPaths>

#include <QSettings>
#include <QDir>

SimpleSqlApplication::SimpleSqlApplication(QObject *parent) : QObject(parent)
{
    m_engine = new QQmlApplicationEngine;

    m_engine->rootContext()->setContextProperty("simple_application", this);

    QSettings settings(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QDir::separator() + "simple_sql.ini", QSettings::IniFormat);
    m_server_host = settings.value("server_host").toString();
    m_server_path = settings.value("server_path", "/").toString();
    m_server_port = settings.value("server_port", 80).toInt();

    m_engine->load(QUrl(QLatin1String("qrc:/main.qml")));
}

bool SimpleSqlApplication::init()
{
}

void SimpleSqlApplication::setToStorage(QString key, QString storage)
{
    m_storage.insert(key, storage);
}

QVariant SimpleSqlApplication::getFromStorage(QString key)
{
    return m_storage.value(key);
}

void SimpleSqlApplication::goBack()
{
    emit back();
}

void SimpleSqlApplication::getRequest(QString request, QVariant data)
{
    if(request == "/buttons")
    {
        QUrl url = createUrl();

        url.setHost(m_server_host);
        url.setPath(m_server_path);

        if(m_server_port != 80)
            url.setPort(m_server_port);

        if(url.scheme() == "")
            url.setScheme("http");

        QUrlQuery query;
        query.addQueryItem("q", "requests");

        url.setQuery(query);

        QNetworkReply* rep = m_nam.get(QNetworkRequest(url));
        connect(rep,
                SIGNAL(finished()),
                SLOT(slotFinished()));

        m_reply_to_requests.insert(rep, request);
    }
    else if(request == "/query")
    {
        QUrl url = createUrl();

        QUrlQuery query;
        query.addQueryItem("q", "query");

        QJsonDocument json_doc = QJsonDocument::fromJson(data.toByteArray());
        QVariantMap json_var = json_doc.toVariant().toMap();
        if(json_var.contains("query_key"))
            query.addQueryItem("key", json_var.value("query_key").toString());
        if(json_var.contains("query_value"))
            query.addQueryItem("value", json_var.value("query_value").toString());

        url.setQuery(query);

        QNetworkReply* rep = m_nam.get(QNetworkRequest(url));
        connect(rep,
                SIGNAL(finished()),
                SLOT(slotFinished()));

        m_reply_to_requests.insert(rep, request);
    }
    else if(request == "/query_prepare")
    {
        m_storage.insert("query_to_prepare", data);
        emit requestFinished(request, QByteArray());
    }
}

void SimpleSqlApplication::slotFinished()
{
    QNetworkReply *rep = (QNetworkReply*)sender();

    QByteArray ba = rep->readAll();

    QVariantMap var_map;

    if(rep->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt() == 200)
    {
        var_map.insert("status", "success");
        var_map.insert("data", ba);
    }
    else
    {
        var_map.insert("status", "error");
        if(rep->error() == QNetworkReply::NoError)
        {
            var_map.insert("data_type", "digit");
            var_map.insert("data", rep->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt());
        }
        else
        {
            var_map.insert("data_type", "text");
            var_map.insert("data", getNetworkErrorString(rep->error()));
        }

    }

    QJsonDocument doc = QJsonDocument::fromVariant(var_map);

    m_storage.insert(m_reply_to_requests.value(rep), doc.toJson());
    emit requestFinished(m_reply_to_requests.value(rep), doc.toJson());
}

bool SimpleSqlApplication::settingsNeed() const
{
    return m_server_host.isEmpty();
}

void SimpleSqlApplication::setSettings(QString server_host, QString server_path, QString server_port)
{
    m_server_host = server_host;

    if(server_path != "")
    {
        m_server_path = server_path;
        if(m_server_path[0] != '/')
            m_server_path = QString("/") + m_server_path;
    }

    if(server_port != "")
        m_server_port = server_port.toInt();

    QSettings settings(QStandardPaths::writableLocation(QStandardPaths::CacheLocation) + QDir::separator() + "simple_sql.ini", QSettings::IniFormat);

    settings.setValue("server_host", m_server_host);
    settings.setValue("server_path", m_server_path);
    settings.setValue("server_port", m_server_port);

    getRequest("/buttons", QVariant());
}

QUrl SimpleSqlApplication::createUrl()
{
    QUrl url;

    url.setHost(m_server_host);
    url.setPath(m_server_path);

    if(m_server_port != 80)
        url.setPort(m_server_port);

    if(url.scheme() == "")
        url.setScheme("http");

    return url;
}





QString SimpleSqlApplication::getNetworkErrorString(QNetworkReply::NetworkError network_error)
{
    QString error;
    switch (network_error) {
    case QNetworkReply::ConnectionRefusedError:
        break;
        error ="the remote server refused the connection (the server is not accepting requests";
        break;
    case QNetworkReply::RemoteHostClosedError:
        error ="the remote server closed the connection prematurely, before the entire reply was received and processed";
        break;
    case QNetworkReply::HostNotFoundError:
        error ="the remote host name was not found (invalid hostname)";
        break;
    case QNetworkReply::TimeoutError:
        error ="the connection to the remote server timed out";
        break;
    case QNetworkReply::OperationCanceledError:
        error ="the operation was canceled via calls to abort() or close() before it was finished.";
        break;
    case QNetworkReply::SslHandshakeFailedError:
        error ="the SSL/TLS handshake failed and the encrypted channel could not be established. The sslErrors() signal should have been emitted.";
        break;
    case QNetworkReply::TemporaryNetworkFailureError:
        error ="the connection was broken due to disconnection from the network, however the system has initiated roaming to another access point. The request should be resubmitted and will be processed as soon as the connection is re-established.";
        break;
    case QNetworkReply::NetworkSessionFailedError:
        error ="the connection was broken due to disconnection from the network or failure to start the network.";
        break;
    case QNetworkReply::BackgroundRequestNotAllowedError:
        error ="the background request is not currently allowed due to platform policy.";
        break;
    case QNetworkReply::TooManyRedirectsError:
        error ="while following redirects, the maximum limit was reached. The limit is by default set to 50 or as set by QNetworkRequest::setMaxRedirectsAllowed(). (This value was introduced in 5.6.)";
        break;
    case QNetworkReply::InsecureRedirectError:
        error ="while following redirects, the network access API detected a redirect from a encrypted protocol (https) to an unencrypted one (http). (This value was introduced in 5.6.)";
        break;
    case QNetworkReply::ProxyConnectionRefusedError:
        error ="the connection to the proxy server was refused (the proxy server is not accepting requests)";
        break;
    case QNetworkReply::ProxyConnectionClosedError:
        error ="the proxy server closed the connection prematurely, before the entire reply was received and processed";
        break;
    case QNetworkReply::ProxyNotFoundError:
        error ="the proxy host name was not found (invalid proxy hostname)";
        break;
    case QNetworkReply::ProxyTimeoutError:
        error ="the connection to the proxy timed out or the proxy did not reply in time to the request sent";
        break;
    case QNetworkReply::ProxyAuthenticationRequiredError:
        error ="the proxy requires authentication in order to honour the request but did not accept any credentials offered (if any)";
        break;
    case QNetworkReply::ContentAccessDenied:
        error ="the access to the remote content was denied (similar to HTTP error 401)";
        break;
    case QNetworkReply::ContentOperationNotPermittedError:
        error ="the operation requested on the remote content is not permitted";
        break;
    case QNetworkReply::ContentNotFoundError:
        error ="the remote content was not found at the server (similar to HTTP error 404)";
        break;
    case QNetworkReply::AuthenticationRequiredError:
        error ="the remote server requires authentication to serve the content but the credentials provided were not accepted (if any)";
        break;
    case QNetworkReply::ContentReSendError:
        error ="the request needed to be sent again, but this failed for example because the upload data could not be read a second time.";
        break;
    case QNetworkReply::ContentConflictError:
        error ="the request could not be completed due to a conflict with the current state of the resource.";
        break;
    case QNetworkReply::ContentGoneError:
        error ="the requested resource is no longer available at the server.";
        break;
    case QNetworkReply::InternalServerError:
        error ="the server encountered an unexpected condition which prevented it from fulfilling the request.";
        break;
    case QNetworkReply::OperationNotImplementedError:
        error ="the server does not support the functionality required to fulfill the request.";
        break;
    case QNetworkReply::ServiceUnavailableError:
        error ="the server is unable to handle the request at this time.";
        break;
    case QNetworkReply::ProtocolUnknownError:
        error ="the Network Access API cannot honor the request because the protocol is not known";
        break;
    case QNetworkReply::ProtocolInvalidOperationError:
        error ="the requested operation is invalid for this protocol";
        break;
    case QNetworkReply::UnknownNetworkError:
        error ="an unknown network-related error was detected";
        break;
    case QNetworkReply::UnknownProxyError:
        error ="an unknown proxy-related error was detected";
        break;
    case QNetworkReply::UnknownContentError:
        error ="an unknown error related to the remote content was detected";
        break;
    case QNetworkReply::ProtocolFailure:
        error ="a breakdown in protocol was detected (parsing error, invalid or unexpected responses, etc.)";
        break;
    case QNetworkReply::UnknownServerError:
        error ="an unknown error related to the server response was detected";
        break;
    default:
        error ="unknown error";
    }
    return error;
}
