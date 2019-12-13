var path = require('path');
var os = require('os');

var posix = process.platform !== 'win32';

module.exports = {
    configPath: path.join(os.homedir(), '.hookagent', 'config.json'),
    execFileOptions: {
        env: Object.assign({}, process.env)
    },
    posix: posix,
    ext: posix ? 'sh' : 'bat'
};
