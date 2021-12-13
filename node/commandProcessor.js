const repl = require('repl');
const commands = require('./commands');

module.exports = (socket) => {
    const myRepl = repl.start({
        prompt: '> ',
        eval: async (inp) => {
            let [command, ...args] = inp.trim().split(' ');
            let cmd = commands.find(c => c.name === command.toLowerCase()) || commands.find(c => c.aliases.includes(command.toLowerCase()));
            if (cmd) await cmd.run(args, socket, commands);
            else console.error('Command not found! Please run ');
            process.stdout.write('> ');
        },
        completer: (line) => {
            const [command, ...args] = line.split(' ');
            if (args.length) {
                const cmd = commands.find(c => c.name === command.toLowerCase()) || commands.find(c => c.aliases.includes(command.toLowerCase()));
                let res;
                if (typeof cmd?.completer === 'function') res = cmd.completer(args, socket, commands);
                if (!res) return [[], line];
                if (!Array.isArray(res)) res = [res];
                res = res.map(c => `${command} ${c}`);
                return [res, line];
            }
            const hits = commands.filter((c) => c.name.startsWith(line)).map(c => c.name);
            return [hits.length ? hits : commands.map(c => c.name), line];
        },
        preview: true
    });
    myRepl.on('exit', process.exit);
};