import QtQuick 2.7

Page1Form {
    id: container

    function clickedQueryFunc(key, value)
    {
        if(value)
        {
            simple_application.getRequest("/query_prepare", key);
        }
        else
        {
            busyIndicator1.visible = true;

            var query_data = {};
            query_data["query_key"] = key;
            simple_application.getRequest("/query", JSON.stringify(query_data));
        }
    }

    Component.onCompleted:  {
        var buttons_data = simple_application.getFromStorage("/buttons");
        statusImage.visible = true;
        if(buttons_data !== "")
        {
            var ret_obj = JSON.parse(buttons_data);
            if(ret_obj.status == "success")
            {
                statusText.visible = false;

                var buttons_obj = JSON.parse(ret_obj.data);
                statusImage.setStatus("success");

                for(var i = 0; i < buttons_obj.buttons.length; i++)
                {
                    var component = Qt.createComponent("SqlButton.qml");
                    if (component.status == Component.Ready) {
                        var button = component.createObject(columnLayout1);
                        button.text = buttons_obj.buttons[i].title;
                        button.key = buttons_obj.buttons[i].key;
                        button.value = buttons_obj.buttons[i].value;

                        button.clickedQuery.connect(clickedQueryFunc);
                    }
                }
            }
            else if(ret_obj.status == "error")
            {
                statusText.visible = true;

                if(ret_obj.data_type == "text")
                    statusText.font.pointSize = 10;
                else
                    statusText.font.pointSize = 72;

                statusText.text = ret_obj.data;

                statusImage.setStatus("error");
            }
        }
    }

    onVisibleChanged: {
        if(visible === true)
        busyIndicator1.visible = false;
    }
}

