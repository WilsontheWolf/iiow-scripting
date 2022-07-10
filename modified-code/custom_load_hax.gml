// make function load_hax

// Misc
timer = 0

// Networking
network_set_config(network_config_connect_timeout, 1000);
socket = network_create_socket(network_socket_tcp);
var port = environment_get_variable("PORT");
if (port == "") {
    port = 6510;
}

var connection = network_connect_raw(socket , "127.0.0.1", port);
global.socket_usable = 0;
if connection < 0 {
    console_log("ERROR: Failed to connect to server")
    network_destroy(socket);
}
else {
    global.socket_usable = 1;
}