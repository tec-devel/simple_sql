import QtQuick 2.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    id: item1
    property alias button_set: button_set
    property alias field_server_host: field_server_host
    property alias field_server_path: field_server_path
    property alias field_esrver_port: field_esrver_port

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

        ColumnLayout {
            id: columnLayout1
            x: -8
            y: 133
            height: 100
            anchors.rightMargin: 8
            anchors.leftMargin: 8
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter

            TextField {
                id: field_server_host
                text: qsTr("")
                Layout.fillWidth: true

                placeholderText: qsTr("Server")
                color: "white"
            }

            TextField {
                id: field_server_path
                text: qsTr("")
                Layout.fillWidth: true

                placeholderText: qsTr("Path")

                color: "white"
            }

            TextField {
                id: field_esrver_port
                text: qsTr("")
                Layout.fillWidth: true

                placeholderText: qsTr("Port")

                validator: IntValidator {bottom: 0; top: 32768}
                color: "white"

            }
        }

        Button {
            id: button_set
            x: -8
            y: 335
            text: qsTr("Set")
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8
        }

    }
}
