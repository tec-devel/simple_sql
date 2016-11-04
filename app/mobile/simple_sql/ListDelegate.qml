import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    height: 32
    width: parent.width

    id:container

    signal back()

    property string list_data_: list_data

    Component.onCompleted: {
        var data_obj = JSON.parse(list_data_);

        for(var i = 0; i < data_obj.length; i++)
        {
            var component = Qt.createComponent("TableCell.qml");
            if (component.status == Component.Ready) {
                var cell = component.createObject(row);
                cell.cell_text.text = data_obj[i];
                cell.cell_count = data_obj.length;
                cell.cell_spacing = row.spacing;
            }
        }
    }

    RowLayout {
        id: row
        height: parent.height

        anchors.left: parent.left
        anchors.right: parent.right
    }
}
