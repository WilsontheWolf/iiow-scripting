module.exports = (x, y, xSpeed, ySpeed) => {
    x = parseInt(x);
    y = parseInt(y);
    if(isNaN(x) || isNaN(y)) return console.log('Please supply x and y.');
    xSpeed = parseInt(xSpeed);
    ySpeed = parseInt(ySpeed);
    if(isNaN(xSpeed)) xSpeed = undefined;
    if(isNaN(ySpeed)) ySpeed = undefined;

    return JSON.stringify({ type: 'tp', who: 'Bob', x, y, spdX: xSpeed, spdY: ySpeed });
};