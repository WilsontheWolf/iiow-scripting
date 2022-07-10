// Read data
var t_buffer = ds_map_find_value(async_load, "buffer");
var data = json_decode(buffer_read(t_buffer, buffer_string));

// Validate data
if(data == -1) {
    console_log("WARNING: Server sent invalid message (json parse failed).");
    return;
}
if(ds_map_exists(data, "default")) {
    console_log("WARNING: Server sent invalid message (json is default).");
    return;
}
if (!ds_map_exists(data, "type")) {
    console_log("WARNING: Server sent invalid message (no type).");
    return;
}


// Process message
handle_message(data);

ds_map_destroy(data);