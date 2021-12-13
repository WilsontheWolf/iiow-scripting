// make function load_hax

socket = network_create_socket(network_socket_tcp);
var connection = network_connect_raw(socket , "127.0.0.1", 6510);
socket_usable = 0;
if connection < 0 {
    console_log("ERROR: Failed to connect to server")
    network_destroy(socket);
}
else {
    socket_usable = 1;
    send_string("Hello Server");
}