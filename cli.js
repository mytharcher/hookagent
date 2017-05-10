#! /usr/bin/env node
var path = require('path');
var currentPlatform = require('./env');

var child_process = require('child_process');
// console.log(process.argv[2])
child_process.execFile(path.join(__dirname, 'bin', `cli.${currentPlatform.ext}`), [process.argv[2]], Object.assign(currentPlatform.execFileOptions,{
	cwd: path.join(__dirname, 'bin')
}), function (error, stdout, stderr) {
	console.log(error,stdout,stderr);
	if (error) {
		console.log(error);
	} else {
		console.log('Deployment done.');
	}
});