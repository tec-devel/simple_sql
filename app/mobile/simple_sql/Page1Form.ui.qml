import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item {
    property alias busyIndicator1: busyIndicator1
    property alias columnLayout1: columnLayout1
    property alias statusImage: statusImage
    property alias statusText: statusText


    Rectangle {
        id: rectangle1
        anchors.topMargin: 0
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#413939"
            }

            GradientStop {
                position: 0.99
                color: "#000000"
            }
        }
        anchors.fill: parent

        StatusImage {
            id: statusImage
            x: 270
            y: 190
            visible: false
        }

        ColumnLayout {
            id: columnLayout1
            anchors.topMargin: 8
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
        }


        Rectangle {
            id: rectangle2
            color: "#00000000"
            anchors.topMargin: 8
            anchors.top: columnLayout1.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8

            BusyIndicator {
                id: busyIndicator1
                x: 282
                y: 134
                visible: false
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                id: statusText
                width: 100
                height: 100
                color: "#ffffff"
                text: qsTr("")
                wrapMode: Text.WordWrap
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 72
            }
        }

    }
}
