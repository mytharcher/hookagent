
var path = require('path');
var currentPlatform = require('./env');
var os = require('os')

var child_process = require('child_process');
// console.log(process.argv[2])
child_process.execFile(path.join(__dirname, 'bin', `cli.${currentPlatform.ext}`), [process.argv[2]], {
	cwd: path.join(__dirname, 'bin'),
	uid: os.userInfo.uid,
	// uid: process.getuid(),
	// uid: 0,
	env: process.env
}, function (error, stdout, stderr) {
	console.log(error,stdout,stderr);
	if (error) {
		console.log(error);
	} else {
		console.log('Deployment done.');
	}
});