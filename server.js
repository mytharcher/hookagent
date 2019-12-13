var fs = require('fs');
var path = require('path');
var child_process = require('child_process');

var express = require('express');
var basicAuth = require('basic-auth');

var currentPlatform = require('./env');

function hook(req, res, next) {
    console.log('Deployment request received: ' + JSON.stringify(req.params));

    var id = req.params[0];
    if (!id) {
        console.log('[400] Bad request. Without project id.');
        return res.status(400).end();
    }

    // find project in config
    var project = config.projects[id];
    if (!project) {
        console.log('[404] Not found. No project named as "' + id + '" found.');
        return res.status(404).end();
    }

    // find branch options in config
    var branch = req.params[1] || config.defaultBranch || 'orign/master';
    var options = project[branch];
    if (!options) {
        console.log('[404] No options of branch "' + branch + '" found. Please check config.');
        return res.status(404).end();
    }

    var branchParam = branch.split('/');
    var remote = branchParam[0];
    if (branchParam.length == 1) {
        remote = config.defaultRemote || 'origin';
    } else {
        branch = branchParam[1];
    }

    // check auth
    var auth = basicAuth(req);
    if (!auth ||
        !auth.pass ||
        options.users.indexOf(auth.name) < 0 ||
        config.users[auth.name] != auth.pass) {
        console.log('[403] Forbidden.');
        return res.status(403).end();
    }

    console.log('Authentication passed.');

    if (!fs.existsSync(options.path)) {
        console.log('[404] No path found for project: "' + id + '"');
        return res.status(404).end();
    }

    const execFileOptions = { ...currentPlatform.execFileOptions, cwd: options.path };

    if (currentPlatform.posix) {
        var uid = parseInt(child_process.execSync('id -u ' + auth.name).toString().trim(), 10);
        
        if (auth.name && !uid) {
            return res.status(404).send('not found');
        }

        execFileOptions.uid = uid;
    }

    res.status(200).send('ok');

    child_process.execFile(path.join(__dirname, 'bin', `deploy.${currentPlatform.ext}`), [
        id,
        remote,
        branch,
        config.gitPath || ''
    ], execFileOptions, function (error, stdout, stderr) {
        console.log(stdout);

        if (error) {
            console.error(error);
        } else {
            console.log('Deployment done.');
        }
    });

    console.log('[200] Deployment started.');
}

var config = require(currentPlatform.configPath);

var agent = express();

agent.get('/', function (req, res, next) {
    // indicate process is running
    res.status(200).send('ok');
});

// [POST]:/project/project-name[@[remote/]branch-name]
agent.post(/\/project\/([\w\.\-]+)(?:@([\w\/\.\-]+))?/i, hook);

agent.listen(config.port, function() {
    console.log("Hook agent started at %s. Listening on %d", new Date(), config.port);
});
