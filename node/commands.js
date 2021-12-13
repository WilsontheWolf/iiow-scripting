const logMessage = require('./logMessage');

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
    }, {
        name: 'log',
        aliases: [],
        desc: 'Log something on client.',
        moreHelp: `log [msg]
Logs the msg.`,
        run: (args, socket) => {
            if(args.length < 1) return console.log('Please supply a message to log.');
            socket.write(logMessage(args.join(' ')));
        }
    }
];