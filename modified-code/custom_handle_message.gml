var data = argument0;

var type = ds_map_find_value(data, "type");
if(type == "log") {
    var msg = ds_map_find_value(data, "msg");
    if(!is_string(msg) || msg == "") {
        console_log("WARNING: Server sent invalid log command (invalid msg).");
        return;
    }
    console_log("SERVER: " + msg);
} else if(type == "exec") {
    var code = ds_map_find_value(data, "code");
    return NSP_execute_string(code);
} else if(type == "eval") {
    var code = ds_map_find_value(data, "code");
    var resp = ds_map_create();
    ds_map_add(resp, "type", "response"); 
    ds_map_add(resp, "id", ds_map_find_value(data, "id")); 
    ds_map_add(resp, "data", NSP_evaluate(code));
    send_string(json_encode(resp));
    return NSP_execute_string(code);
} else {
    console_log("WARNING: Server sent invalid command (invalid type). Please make sure you have the latest version of the client code.");
}