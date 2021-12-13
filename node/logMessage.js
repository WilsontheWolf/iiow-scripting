module.exports = (msg) => {
    if (typeof msg !== 'string') {
        if (typeof msg === 'object') {
            msg = JSON.stringify(msg);
        } else {
            msg = `${msg}`;
        }
    }
    return JSON.stringify({ type: 'log', msg });
};