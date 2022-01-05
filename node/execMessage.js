// TODO: make the messages easier to use.

module.exports = (code) => {
    if (typeof code !== 'string') {
        return 'Code must be a string.';
    }
    return JSON.stringify({ type: 'exec', code: code });
};