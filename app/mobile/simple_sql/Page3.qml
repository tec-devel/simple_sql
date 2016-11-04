import QtQuick 2.4

Page3Form {
    sqlHeader1.onBack: {
        simple_application.goBack();
    }

    onVisibleChanged: {
        if(visible === true)
        {
            busyIndicator1.visible = false;
            text_field_value.visible = true;
        }
    }

    button_send.onClicked: {

        text_field_value.visible = false;
        busyIndicator1.visible = true;

        var query_data = {};

        query_data["query_key"] = simple_application.getFromStorage("query_to_prepare");
        query_data["query_value"] = text_field_value.text;

        simple_application.getRequest("/query", JSON.stringify(query_data));
   }
}
