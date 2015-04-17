var fs = require('fs');
var path = require('path');
var child_process = require('child_process');

var express = require('express');
var basicAuth = require('basic-auth');



function hook(req, res, next) {
	var id = req.params[0];
	if (!id) {
		console.log('[400] Bad request. Without project id.');
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

	var branch = req.params[1] || project.branch || config.defaultBranch;

	if (!fs.existsSync(project.path)) {
		console.log('[500] No path found for project: "' + id + '"');
		return res.status(500).end();
	}

	child_process.execFile(path.join(process.cwd(), 'bin/deploy.sh'), [id, branch, project.shell || ''], {
		cwd: project.path,
		uid: parseInt(child_process.execSync('id -u ' + auth.name), 10)
	}, function (error, stdout) {
		if (error) {
			console.log(error);
		}
		console.log('Deployment done.');
	});

	console.log('[200] Deployment started.');
	return res.status(200).end();
}

var config = require('/etc/hookagent.json');

var agent = express();

agent.get('/', function (req, res, next) {
	// indicate process is running
	res.status(200).send('ok');
});

// [POST]:/project/project-name<@branch-name>
agent.post(/\/project\/([\w-]+)(?:@([\w-]+))?/i, hook);

agent.listen(config.port, function() {
	console.log("Hook agent started at %s. Listening on %d", new Date(), config.port);
});
