const requests = new Map();

const registerTimeout = (id, timeout) => {
    if (timeout === 0) return;
    setTimeout(() => {
        if (requests.has(id)) {
            const request = requests.get(id);
            requests.delete(id);
            request.reject(new Error('Request timed out'));
        }
    }, timeout);
};

module.exports = (socket, data, timeout = 5000) => {
    // Just need a unique id.
    const id = `${Date.now()}-${Math.floor(Math.random() * 100)}`;
    socket.write(JSON.stringify({ ...data, id }));
    const res = {
        id,
        timeout
    };
    res.promise = new Promise((resolve, reject) => {
        res.resolve = resolve;
        res.reject = reject;
    });
    requests.set(id, res);
    registerTimeout(id, timeout);
    return res.promise;
};

module.exports.response = ({id, data}) => {
    if (!requests.has(id)) return null;
    const request = requests.get(id);
    requests.delete(id);
    request.resolve(data);
    return request;
};