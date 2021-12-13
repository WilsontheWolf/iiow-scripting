const Net = require('net');
const commandProcessor = require('./commandProcessor');
const logMessage = require('./logMessage');
const port = 6510;

const server = Net.createServer();

let connected = false;

server.on('connection', (socket) => {
    if(connected) {
        socket.write(logMessage('A client has already connected to this server. Please restart the server and try again later.'));
        socket.destroy();
        return;
    }
    connected = true;
    console.log('client connected');
    socket.on('data', (data) => {
        console.log(data.toString());
    });
    socket.on('close', () => {
        console.log('client disconnected.');
        process.exit();
    });

    commandProcessor(socket);
});

server.listen(port);

console.log('Waiting for client...');