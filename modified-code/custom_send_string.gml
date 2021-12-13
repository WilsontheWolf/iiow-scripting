// Make function send_string

var data = argument0;
if(socket_usable) {
    var send_buffer = buffer_create(256, buffer_grow, 1);
    buffer_seek(send_buffer, buffer_seek_start, 0);
    // Write our message
    buffer_write(send_buffer, buffer_string, data);
    // Send the message
    network_send_raw(socket, send_buffer, buffer_tell(send_buffer));
    // Remove the buffer from memory
    buffer_delete(send_buffer);
}