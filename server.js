var fs = require('fs');
var path = require('path');
var child_process = require('child_process');

var express = require('express');
var basicAuth = require('basic-auth');



function check(req, res, next) {
	var id = req.params[0];
	if (!id) {
		console.log('[400] Bad request. Without project id.')
		return res.status(400).end();
	}

	var project = config.projects[id];
	if (!project) {
		console.log('[404] Not found. No project named "' + id + '" found.');
		return res.status(404).end();
	}

	var auth = basicAuth(req);
	if (!auth ||
		!auth.pass ||
		project.users.indexOf(auth.name) < 0 ||
		config.users[auth.name] != auth.pass) {
		console.log('[403] Forbidden.');
		return res.status(403).end();
	}

	console.log('Authentication passed.');

	next();
}

function deploy(req, res, next) {
	var id = req.params[0];
	var project = config.projects[id];
	var branch = req.params[1] || project.branch || config.defaultBranch;

	if (!fs.existsSync(project.path)) {
		console.log('[500] No path found for project: "' + id + '"');
		return res.status(500).end();
	}

	var flag = path.join(config.runningPath, id);
	if (!fs.existsSync(flag)) {
		fs.writeFileSync(flag, '', {mode: 0644});

		child_process.execFile(path.join(process.cwd(), 'bin/deploy.sh'), [branch, project.shell || ''], {
			cwd: project.path
		}, function (error, stdout) {
			if (error) {
				console.log(error);
			}
			fs.unlinkSync(flag);
			console.log('Deployment done.');
		});

		console.log('[200] Deployment started.');
		return res.status(200).end();
	} else {
		console.log('[409] Deployment working.');
		return res.status(409).end();
	}
}

var config = require('/etc/hookagent.json');

var app = express();

app.get('/', function (req, res, next) {
	res.status(200).send();
});

// [POST]:/project/project-name<@branch-name>
app.post(/\/project\/([\w-]+)(?:@([\w-]+))?/i, check, deploy);

app.listen(config.port, function() {
	console.log("Deploy agent started at %s. Listening on %d", new Date(), config.port);
});
