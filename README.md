Git webhook deploy agent
==========

Git webhook agent for server auto-deployment.

For sysadmins simply setup a post hook agent on server to deploy git projects like PaaS from your using third-party git service.

Usage
----------

### On your server ###

Hookagent require [PM2][] to start service, so make sure it has been installed in global:

    $ sudo npm install -g pm2

Then use npm install hookagent:

    $ sudo npm install -g hookagent

After installed you can use this commands to start the agent:

    $ hookagent config
    $ hookagent start

### Get ready your repository ###

Additional things about git you should make sure:

* Project repository alread cloned once from 3rd-party git service.

* All repository files(folders) is own by the specific user(s) you configured in the config file (`/etc/hookagent.json`, see below).

* Within the user, the ssh-key has been generated (no password), and set as deploy key in 3rd-party git service.

* The ssh-key has been used at least once, to make sure it has been add to the list of known hosts of the service.

### Post hook ###

Set a git post hook in the admin panel of your repository like this:

    [POST]:http://user:password@deploy.yourserver.com:6060/project/id@branch

* `user:password` is reqired part in post URL. The agent will check the request with HTTP basic authentication to avoid mistake request.

* `6060` as port is set in the config, you can change it as you wish.

* `/project/:id` is the router, `@branch` is optional default to `master`.

### Configuration ###

Before start the agent first time, run `hookagent config` to generate a config file named `hookagent.json` in `/etc` folder, maybe need `sudo` prefix.

Here is a sample of configuration structure:

```javascript
{
    // The HTTP listening port
    "port": 6060,
    // Default branch which will be updated when not set in post request
    "defaultBranch": "master",
    // An empty folder to place flags which task is running
    "runningPath": "/var/deployagent.running",

    // Projects map. ID: object
    "projects": {
        "sample": {
            // Project path
            "path": "/var/www/sample",

            // Task to be run after git pull, such as build etc.
            // "shell": "./build.sh",

            // Users in list allow to trigger deploy
            "users": ["abc"]
        }
    },

    // Users list for HTTP basic authentication. ID: password
    // Each user ID should match server user name.
    "users": {
        "abc": "ba1f2511fc30423bdbb183fe33f3dd0f"
    }
}
```

Once the config file generated, run the `hookagent config` will show the content.

Roadmap
-----------

* Add logger.
* Add Github and Bitbucket post data parsing to avoid none updated pulling.
* Add admin panel using basic authentication.
* Use SQLite or other database to manage config data.
* Add RSA authentication instead of basic HTTP.

MIT Licensed
----------

-EOF-

[PM2]: https://github.com/Unitech/PM2
