Git webhook deploy agent
==========

Git webhook agent for server auto-deployment.

Usage
----------

### On a server ###

    $ sudo npm install -g hookagent
    $ sudo npm install -g pm2
    $ hookagent config
    $ hookagent start

### Post hook ###

When a Git hook service send a post request:

    [POST]:http://user:password@deploy.yourserver.com:6060/project/id@dev

The agent will check the request with HTTP basic authentication to avoid mistake request.

### Configuration ###

Before start the agent first time, run `hookagent config` to generate a config file named `hookagent.json` in `/etc` folder, maybe need `sudo` prefix.

Here is a sample of configuration structure:

    {
        // The HTTP listening port
        "PORT": 6060,
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
