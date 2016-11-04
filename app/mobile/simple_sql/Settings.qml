import QtQuick 2.4

SettingsForm {

    button_set.onClicked: {

        simple_application.setSettings(field_server_host.text,
                                       field_server_path.text,
                                       field_esrver_port.text);

    }
}
