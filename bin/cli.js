#! /usr/bin/env node
var path = require('path');
var currentPlatform = require('../env');

var child_process = require('child_process');
// console.log(process.argv[2])
child_process.execFile(path.join(__dirname, `cli.${currentPlatform.ext}`), [
	process.argv[2]
],
{
	env: process.env,
	cwd: __dirname
}, function (error, stdout, stderr) {
	if (error) {
		console.error(error);
	} else {
		console.log(stdout);
	}
});
