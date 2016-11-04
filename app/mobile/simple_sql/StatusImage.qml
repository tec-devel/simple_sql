import QtQuick 2.4

Image {
    id: image1
    width: 100
    height: 100

    opacity: 0.2

    sourceSize.height: 100
    sourceSize.width: 100
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    smooth: true
    mipmap: true

    function setStatus(status)
    {
        if(status === "success")
        {
            source = "img/success.png";
        }
        else if(status === "error")
        {
            source = "img/fail.png";
        }
    }
}
