Git webhook deploy agent
==========

Git webhook agent for server auto-deployment.

Usage
----------

### On a server ###

Hookagent require [PM2][] to start service, so make sure it has been installed in global:

    $ sudo npm install -g pm2

Then use npm install hookagent:

    $ sudo npm install -g hookagent

After installed you can use this commands to start the agent:

    $ hookagent config
    $ hookagent start

### Post hook ###

Set a git post hook in the admin panel of your repository like this:

    [POST]:http://user:password@deploy.yourserver.com:6060/project/id@branch

`user:password` is reqired part in post URL. The agent will check the request with HTTP basic authentication to avoid mistake request.

`6060` as port is set in the config, you can change it as you wish.

`/project/:id` is the router, `@branch` is optional default to `master`.

### Configuration ###

Before start the agent first time, run `hookagent config` to generate a config file named `hookagent.json` in `/etc` folder, maybe need `sudo` prefix.

Here is a sample of configuration structure:

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
        "users": {
            "abc": "ba1f2511fc30423bdbb183fe33f3dd0f"
        }
    }

Once the config file generated, run the `hookagent config` will show the content.

Roadmap
-----------

* Add logger.
* Add Github and Bitbucket post data parsing to avoid none updated pulling.
* Add admin panel using basic authentication.
* Use SQLite or other database to manage config data.

MIT Licensed
----------

-EOF-

[PM2]: https://github.com/Unitech/PM2
