const Net = require('net');
const util = require('util');
const commandProcessor = require('./commandProcessor');
const logMessage = require('./logMessage');
const { response } = require('./requestData');
const port = 6510;

const server = Net.createServer();

let connected = false;

server.on('connection', (socket) => {
    if (connected) {
        socket.write(logMessage('A client has already connected to this server. Please restart the server and try again later.'));
        socket.destroy();
        return;
    }
    connected = true;
    console.log('client connected');
    socket.on('data', (data) => {
        try {
            const parsed = JSON.parse(data.slice(0, -1));
            const command = parsed.type;
            if (command === 'response') {
                response(parsed);
            }
        } catch (e) {
            console.log(e);
        }
    });
    socket.on('close', () => {
        console.log('client disconnected.');
        process.exit();
    });

    commandProcessor(socket);
});

server.listen(port);

console.log('Waiting for client...');