var path = require('path');
var os = require('os');

var currentPlatform = {
    configPath: path.join(os.homedir(), '.hookagent', 'config.json')
};

Object.assign(currentPlatform, process.platform === 'win32'
    ? {
        ext: 'bat',
        posix: false,
        execFileOptions: {
            env: process.env
        }
    }
    : {
        ext: 'sh',
        posix: true,
        execFileOptions: {
            env: process.env
        }
    }
);

module.exports = currentPlatform;
