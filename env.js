var path = require('path');
var os = require('os');

var currentPlatform = {
    configPath: path.join(os.homedir(), '.hookagent', 'config.json')
};

Object.assign(currentPlatform, process.platform === 'win32' ?
    {
        ext: 'bat',
        execFileOptions: {
            env: process.env
        }
    } :
    {
        ext: 'sh',
        execFileOptions: {
            uid: process.getuid(),
            env: process.env
        }
    }
);

module.exports = currentPlatform;
