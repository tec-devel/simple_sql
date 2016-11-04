<?php

//include 'functions.php';
//phpinfo();
//$headers = "Content-type: text/html; charset=utf-8 \r\n";

$host = '81.177.141.225'; // адрес сервера
$database = 'sandwich_optovik-test'; // имя базы данных
$user = '037300005_test'; // имя пользователя
$password = '7uspF>rghdvn'; // пароль
// подключаемся к серверу
$link = mysqli_connect($host, $user, $password, $database)
        or die("Ошибка" . mysqli_error($link));

$query["title"] = 'Запрос 1';
$query["value"] = false;
$query["sql"] = 'select * from opt_sclads where `id`>3';

$queries["0"] = $query;

$query["title"] = 'Запрос 2';
$query["value"] = false;
$query["sql"] = 'select * from opt_sclads where `id`>0';

$queries["1"] = $query;

$query["title"] = 'Запрос 3';
$query["value"] = true;
$query["sql"] = 'select * from opt_sclads where `id`>%value%';

$queries["2"] = $query;

$query["title"] = 'Запрос на update';
$query["value"] = true;
$query["sql"] = 'update opt_sclads set descr=\'%value%\'  where `id`=4';

$queries["3"] = $query;

$query["title"] = 'Запрос на update 4';
$query["value"] = true;
$query["sql"] = 'update opt_sclads set descr=\'%value%\'  where `id`=4';

$queries["4"] = $query;



$q = htmlspecialchars($_GET["q"]);

if ($q == "requests") {
    $i = 0;
    $ret_json_list = array();

    foreach ($queries as $key => $value) {
        $query_obj['title'] = $value['title'];
        $query_obj['value'] = $value['value'];
        $query_obj['key'] = $key;

        $ret_json_list[$i++] = $query_obj;
    }

    $ret_json_str["buttons"] = $ret_json_list;

    print json_encode($ret_json_str);
    
    return;
} else if ($q == "query") {
    $key = htmlspecialchars($_GET["key"]);
    
    if(intval($key) < 0 ||
            intval($key) > count($queries) - 1)
    {
            $error_answer["status"] = "error";
            $error_answer["reason"] = "requested query is not recogrized!";

            print json_encode($error_answer);
            return;
    }
    
    $value = htmlspecialchars($_GET["value"]);

    $query = $queries[$key];
    $sql = $query["sql"];

    if ($query["value"] == true) {
        if (empty($value)) {
            $error_answer["status"] = "error";
            $error_answer["reason"] = "you have not specified value for this request!";

            print json_encode($error_answer);
            return;
        }
        $sql = str_replace("%value%", $value, $sql);
    }
    
    $query_type = explode(" ", $sql);
    
    mysqli_query($link, "SET CHARACTER SET 'utf8'");

    $result = mysqli_query($link, $sql);
    $errors = mysqli_error_list($link);

    
    if(count($errors) > 0)
    {
        $error_answer["status"] = "error";
        
        foreach ($errors as $err) {
            $error_strings = $error_strings . $err["error"] . " ";
        }
        
        $error_answer["reason"] = $error_strings;
        print json_encode($error_answer);

        return;
    }

    
    if($query_type[0] == "select")
    {
    $ret_result = array();
    $ret_result_data = array();
    $headers = array();
    $row_list_data = array();
    $row_list = array();
    $i = 0;
    $j = 0;

    while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
        if (empty($headers)) {
            $headers = array_keys($row);
        }

        $j = 0;
        foreach ($headers as $value1) {
            
            $test_value = $row[$value1];
            
            $cell_data = mysqli_fetch_field_direct($result, $j);
            
            $field_type_varchar = 253;
            $field_type_char = 254;
            
            if($cell_data->type == $field_type_varchar || $cell_data->type == $field_type_char)
            {
                $test_value = trim($test_value);
            }
            
            $row_list_data[$j] = $test_value;
            $j++;
        }

        $row_list[$i++] = $row_list_data;
    }
    
    if(json_encode($ret_result_data) != FALSE)
    {
        $ret_result_data["status"] = "success";
        $ret_result_data["type"] = $query_type[0];
        $ret_result_data["sql"] = $sql;
        $ret_result_data["headers"] = $headers;
        $ret_result_data["rows"] = $row_list;
        print json_encode($ret_result_data);
        
        return;
    }
    else
    {
        $error_answer["status"] = "error";
        $error_answer["reason"] = json_last_error_msg();
        print json_encode($error_answer);
        
        return;
    }
    
    }
    else if($query_type[0] == "update")
    {
        if($result == TRUE)
        {
            $ret_result_data["status"] = "success";
            $ret_result_data["type"] = $query_type[0];
            $ret_result_data["sql"] = $sql;
            print json_encode($ret_result_data);
            return;
        }
        else
        {
            $error_answer["status"] = "error";
            $error_answer["reason"] = "update non implemented yet";
            print json_encode($error_answer);
        }
        
        return;
    }
}

// выполняем операции с базой данных
// закрываем подключение
mysqli_close($link);
?>