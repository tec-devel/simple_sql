import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Simple Sql")

    Component.onCompleted: {
         simple_application.back.connect(goBack);

        simple_application.requestFinished.connect(requestFinished);

        if(simple_application.settingsNeed())
        {
            busy_indicator.visible = false;
            stackView.push(settings);
        }
        else
        {
            busy_indicator.visible = true;
            simple_application.getRequest("/buttons");
        }
    }


    function requestFinished(request, data)
    {
        if(request === "/buttons")
        {
            busy_indicator.visible = false;

            stackView.push(first);
            console.log(data);
        }
        else if(request === "/query")
        {
            stackView.push(second);
            console.log(data);
        }
        else if(request === "/query_prepare")
        {
            stackView.push(third);
        }
        else if(request === "/query_prepare")
        {
            stackView.push(third);
        }
//        "/settings_wrote"
    }

    function goBack()
    {
        if(stackView.depth > 0)
            stackView.pop();
    }

    Timer {
        id: test_timer

        interval: 500

        onTriggered: {
            var data =
                    {"columns" :
                    [
                    {"id_": 4, "storage": "Склад 4", "description":"Описание 4", "field":"450456", "field_one":"0"},
                    {"id_": 5, "storage": "Склад 5", "description":"Описание 5", "field":"550456", "field_one":"0"},
                    {"id_": 6, "storage": "Склад 6", "description":"Описание 6", "field":"650456", "field_one":"0"},
                    {"id_": 7, "storage": "Склад 7", "description":"Описание 7", "field":"750456", "field_one":"0"},
                    {"id_": 8, "storage": "Склад 8", "description":"Описание 8", "field":"850456", "field_one":"0"}
                ]
            };

            simple_application.setToStorage("test_data", JSON.stringify(data));

            stackView.push(second)
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent

        Keys.onPressed: {
            if(event.key === Qt.Key_Back)
            {
                if(stackView.depth > 1)
                    stackView.pop();
            }
        }
    }

    Component {
        id: first

        Page1 {

        }
    }

    Component {
        id: second
        Page2 {
        }
    }

    Component {
        id: third
        Page3 {
        }
    }

    Component {
        id: settings
        Settings {
        }
    }

    BusyIndicator {
        id: busy_indicator

        anchors.verticalCenter:
            stackView.verticalCenter
        anchors.horizontalCenter:
            stackView.horizontalCenter

        visible: true;
    }


}
