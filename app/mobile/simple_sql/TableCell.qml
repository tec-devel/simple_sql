import QtQuick 2.4
import QtQuick.Layouts 1.0

Rectangle {
    id: rectangle5
    height: 32
    width: text1.width

    color: "transparent"

    property alias cell_text: text1
    property int cell_count: 0
    property int cell_spacing: 0

    Layout.preferredWidth: (parent.width / cell_count) - cell_spacing

    clip: true

//    border.width: 1
//    border.color: "lightgray"
    
    Text {
        id: text1
        text: ""
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 12
    }
}
