import QtQuick 2.4

Page2Form {
    header.onBack: {
        simple_application.goBack();
    }

    Component.onCompleted: {

        data_model.clear();

        var data_str = simple_application.getFromStorage("/query");

        var ret_obj = JSON.parse(data_str);


        if(ret_obj.status === "success")
        {
            var data_obj = JSON.parse(ret_obj.data);

            image1.setStatus(data_obj.status);

            if(data_obj.status  === "success")
            {
                rect_error.visible = false;
                listView1.visible = true;

                header.setHeadetText(data_obj.sql);

                if(data_obj.type == "select")
                {
                    data_model.append({"list_data" : JSON.stringify(data_obj.headers)});

                    for(var i = 0; i < data_obj.rows.length; i++)
                    {
                        data_model.append({"list_data" : JSON.stringify(data_obj.rows[i])});
                    }
                }
                else if(data_obj.type == "update")
                {
                }
            }
            else
            {
                image1.setStatus(data_obj.status);

                rect_error.visible = true;
                listView1.visible = false;

                text_error.text = data_obj.reason;
            }
        }
        else
        {
            image1.setStatus(ret_obj.status);

            rect_error.visible = true;
            listView1.visible = false;

            text_error.text = ret_obj.data;
        }
    }
}

