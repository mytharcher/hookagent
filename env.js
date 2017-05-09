var path = require('path');
var os = require('os');
var ext = '';
var configPath = '';

if(process.platform === 'win32') {
    ext = 'bat';
    configPath = path.join(process.env.windir, 'system32');
    options = {
        env: process.env
    }
}else {
    ext = 'sh';
    configPath = '/etc';
    options = {
        uid: process.getuid(),
        env: process.env
    }
}

const currentPlatform = {
    ext: ext,
    configPath: configPath,
    execFileOptions: options
};

module.exports = currentPlatform;