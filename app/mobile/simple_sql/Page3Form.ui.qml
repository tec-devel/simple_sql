import QtQuick 2.4
import QtQuick.Controls 2.0

Item {
    property alias text_field_value: text_field_value
    property alias button_send: button_send
    property alias busyIndicator1: busyIndicator1
    property alias sqlHeader1: sqlHeader1

    Rectangle {
        id: rectangle1
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#413939"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        anchors.fill: parent

        TextField {
            id: text_field_value
            x: 100
            y: 180
            text: ""
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            placeholderText: "Value"

            color: "white"
        }

        Button {
            id: button_send
            y: 424
            text: qsTr("Send")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.right: parent.right
            anchors.rightMargin: 8
        }

        BusyIndicator {
            id: busyIndicator1
            x: 290
            y: 210
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        SqlHeader {
            id: sqlHeader1
        }
    }
}
