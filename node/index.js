const Net = require('net');
const util = require('util');
const commandProcessor = require('./commandProcessor');
const logMessage = require('./logMessage');
const { response } = require('./requestData');
const tpMessage = require('./tpMessage');
const port = process.env.PORT || 6510;

const server = Net.createServer();

let connected = false;

let secondSocket = null;

server.on('connection', (socket) => {
    if (connected) {
        socket.write(logMessage('A client has already connected to this server. Please restart the server and try again later.'));
        // socket.destroy();
        secondSocket = socket;
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
            } else if (command === 'game_state') {
                // console.log(parsed);
                if(parsed.state !== 'game') return;
                const { player_x: x, player_y: y, player_spd_x: spdX, player_spd_y: spdY } = parsed;
                secondSocket?.write(tpMessage(x, y, spdX, spdY));
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