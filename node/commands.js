const execMessage = require('./execMessage');
const evalMessage = require('./evalMessage');
const requestData = require('./requestData');
const logMessage = require('./logMessage');
const createMessage = require('./createMessage');
const tpMessage = require('./tpMessage');

let testX = -10;
let testY = -10;

module.exports = [
    {
        name: 'help',
        aliases: ['h', 'commands'],
        desc: 'Shows the help.',
        moreHelp: `help [COMMAND]
If no COMMAND is supplied it lists all commands. Otherwise it shows info on that command.`,
        completer: (args, socket, commands) => {
            args = args.join(' ');
            const hits = commands.filter((c) => c.name.startsWith(args)).map(c => c.name);
            return hits.length ? hits : commands.map(c => c.name);
        },
        run: (args, socket, commands) => {
            if (!args[0]) {
                const longest = commands.reduce((long, cmd) => Math.max(long, cmd.name.length), 0);
                console.log('Below is a list of commands. For more info on a certain command, run "help [command]".\n' +
                    commands.map(cmd =>
                        `${cmd.name}${' '.repeat(longest - cmd.name.length)} :: ${cmd.desc}`
                    ).join('\n')
                );
            } else {
                let cmd = commands.find(c => c.name === args.join().toLowerCase()) || commands.find(c => c.aliases.includes(args.join().toLowerCase()));
                if (cmd)
                    console.log(`${cmd.name} :: ${cmd.desc}\
${cmd.moreHelp ? '\n' + cmd.moreHelp : ''}\
${cmd.aliases[0] ? `\nAliases :: ${cmd.aliases.join(', ')}` : ''}`);
                else console.log(`No command found called ${args.join(' ')}`);
            }
        }
    },
    {
        name: 'log',
        aliases: [],
        desc: 'Log something on client.',
        moreHelp: `log [msg]
Logs the msg.`,
        run: (args, socket) => {
            if (args.length < 1) return console.log('Please supply a message to log.');
            socket.write(logMessage(args.join(' ')));
        }
    },
    {
        name: 'exec',
        aliases: ['run'],
        desc: 'Run code.',
        moreHelp: `exec [code]
Executes the given code on the client.`,
        run: (args, socket) => {
            if (args.length < 1) return console.log('Please supply a string to exec.');
            socket.write(execMessage(args.join(' ')));
        }
    },
    {
        name: 'eval',
        aliases: [],
        desc: 'Evaluate code.',
        moreHelp: `eval [code]
Evaluates the given code on the client.`,
        run: async (args, socket) => {
            if (args.length < 1) return console.log('Please supply a string to exec.');
            console.log(await requestData(socket, evalMessage(args.join(' '))));
        }
    },
    {
        name: 'create',
        aliases: [],
        desc: 'Create a new iisland.',
        moreHelp: `create [name]`,
        run: async (args, socket) => {
            socket.write(createMessage());
        }
    },
    {
        name: 'tp',
        aliases: [],
        desc: 'tp bob.',
        moreHelp: `tp [x] [y]
tp [x] [y] [xSpeed] [ySpeed]`,
        run: async (args, socket) => {
            if (args.length < 2) return console.log('Please supply x and y.');
            socket.write(tpMessage(...args));
        }
    },
    {
        name: 'test',
        aliases: [],
        desc: 'Test command.',
        moreHelp: `test [x] [y]`,
        run: async (args, socket) => {
            socket.write(JSON.stringify({ type: 'test' }))
        }
    }
];