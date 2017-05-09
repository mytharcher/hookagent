Git webhook deploy agent
==========

For sysadmins simply setup a post hook agent on server to deploy git projects like PaaS from your using third-party git service.

Usage
----------

### Requirement ###

* node version >= 0.12.0
* [PM2][] installed in global: `sudo npm install -g pm2`

### On your server ###

    $ sudo npm install -g hookagent

After installed you can use this commands to start the agent:

    $ sudo hookagent config
    $ sudo su -c "hookagent start" # start the process as root

### Get ready your repository ###

Additional things about git you should make sure:

* Project repository alread cloned once from 3rd-party git service.

* All repository files(folders) is own by the specific user(s) you configured in the config file (`/etc/hookagent.json`, see below).

* Within the user, the ssh-key has been generated (no password), and set as deploy key in 3rd-party git service.

* The ssh-key has been used at least once, to make sure it has been add to the list of known hosts of the service.

### Post hook ###

Set a git post hook in the admin panel of your repository like this:

    [POST]:http://user:password@deploy.yourserver.com:6060/project/id@remote/branch

* `user:password` is reqired part in post URL. The agent will check the request with HTTP basic authentication to avoid mistake request.

* `6060` as port is set in the config, you can change it as you wish.

* `/project/:id` is the router, `@remote/branch` is optional default to `origin/master`. If branch (or with remote) is set in hook URL, the part after `@` should be exactly match the config (see below).

### Configuration ###

Before start the agent first time, run `hookagent config` to generate a config file named `hookagent.json` in `/etc` folder, maybe need `sudo` prefix.

Here is a sample of configuration structure:

```javascript
{
    // The HTTP listening port
    "port": 6060,
    // Default remote will be used if not set in post request
    "defaultRemote": "origin",
    // Default branch which will be updated when not set in post request
    "defaultBranch": "master",

    // Projects map. ID: object
    "projects": {
        "sample": {
            // branch
            "master": {
                // Project path
                "path": "/var/www/sample",

                // Task to be run after git pull, such as build etc.
                // "shell": "./build.sh",

                // Users in list allow to trigger deploy
                "users": ["abc"]
            },
            "dev": {
                "path": "/var/www/test",
                "users": ["abc"]
            }
        }
    },

    // Users list for HTTP basic authentication. ID: password
    // Each user ID should match server user name.
    "users": {
        "abc": "ba1f2511fc30423bdbb183fe33f3dd0f"
    },
    // add git path for windows server
    "gitPath": "C:\\Program Files\\Git\bin\git.exe"
}
```

**Make sure** that when using different branches in one project, the `path` of branch shouldn't be same on one server. This is just for different usage (such as testing) base on branch mapping.

Once the config file generated, run the `hookagent config` will open the content with `vim`.

**When you use to Windows server, you should use node as default open method to javascript.**

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
