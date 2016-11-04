import QtQuick 2.4

Rectangle {
    id: rectangle2
    height: 48
    color: "#00000000"
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left

    signal back()

    function setHeadetText(header_text)
    {
        text_header.text = header_text;
    }
    
    Rectangle {
        id: rect_back_button
        width: 48
        color: "#1d1d1d"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        
        Image {
            id: image1
            anchors.rightMargin: 4
            anchors.leftMargin: 4
            anchors.bottomMargin: 4
            anchors.topMargin: 4
            anchors.fill: parent
            source: "img/arrow-left.png"
            mipmap: true
            
        }
        
        MouseArea {
            id: mouse_area_back
            anchors.fill: parent

            onClicked: {
                rectangle2.back();
            }
        }
    }
    
    Rectangle {
        id: rectangle4
        color: "#1d1d1d"
        clip: true
        anchors.leftMargin: 1
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.left: rect_back_button.right
        
        Text {
            id: text_header
            y: 25
            color: "#fffbfb"
            text: qsTr("")
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 14
        }
    }
}
