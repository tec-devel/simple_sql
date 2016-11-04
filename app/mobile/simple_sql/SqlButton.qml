import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Button {
    property string key: ""
    property bool value: false

    signal clickedQuery(string key, bool value)

    id: button
//    width: 500 // parent.width
    height: 64

    Layout.preferredWidth: parent.width

    onClicked: {
        clickedQuery(button.key, button.value);
    }
}
