var path = require('path');
var os = require('os');
var ext = '';
var configPath = '';
var options = {
    uid: os.userInfo().uid,
    env: process.env,
};

if(process.platform === 'win32') {
    ext = 'bat';
    configPath = path.join(process.env.windir, 'system32');
}else {
    ext = 'sh';
    configPath = '/etc';
}

const currentPlatform = {
    ext: ext,
    configPath: configPath,
    execFileOptions: options
};

module.exports = currentPlatform;