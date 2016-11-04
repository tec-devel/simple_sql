import QtQuick 2.4

Item {
    id: item1
    property alias listView1: listView1
    property alias data_model: data_model
    property alias text_error: text_error
    property alias rect_error: rect_error
    property alias header: header
    property alias image1: image1



    Rectangle {
        id: rectangle1
        anchors.fill: parent
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
    }


    StatusImage {
        id: image1
    }

    ListView {
        id: listView1
        spacing: 2
        anchors.topMargin: 8
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 8
        anchors.rightMargin: 8
        anchors.leftMargin: 8



        delegate:    ListDelegate {

        }

        model: data_model
    }



    SqlHeader {
        id: header
        x: 8
    }


    Rectangle {
        id: rect_error
        color: "#00000000"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.right: parent.right
        anchors.top: header.bottom
        anchors.topMargin: 8

        Text {
            id: text_error
            color: "#ffffff"
            text: qsTr("")
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pixelSize: 12
        }
    }


    ListModel {
        id: data_model
    }




}
