
set APP_NAME=hookagent

:: get current user
set currentUser=%username%

:: get project root path
set LIB_PATH=%1

:: get configPath from parameters
set configPath=%2

set SERVER_SCRIPT=%LIB_PATH%\server.js
set CONFIG_SOURCE=%LIB_PATH%\config.json
set CONFIG_TARGET=%configPath%\%APP_NAME%.json
set LOG_PATH=%UserProfile%\log\%APP_NAME%

:: check if exists config file.
if not exist %CONFIG_TARGET% (
    echo No config file found as %CONFIG_SOURCE%. Please run '%APP_NAME% config' first to generate default config.
    pause
    exit
)

:: check if exists log path
if not exist %LOG_PATH% md %LOG_PATH%

:: get user op
set op=%3

:: config
if "%op%" == "config" (
    echo %APP_NAME% configurations %CONFIG_TARGET%
    notepad %CONFIG_TARGET%
    pause
    exit
)
if "%op%" == "start" (
    echo Starting deploy agent server...
    pm2 start %SERVER_SCRIPT% --name %APP_NAME%
    pause
    exit
)
if "%op%" == "stop" (
    echo Stopping deploy agent server...
    pm2 stop %APP_NAME%
    pause
    exit
)
if "%op%" == "restart" (
    echo Restarting deploy agent server...
    pm2 restart %APP_NAME%
    pause
    exit
)
if "%op%" == "update" (
    echo Updating %APP_NAME%
    npm update -g hookagent
    pause
    exit
)

echo Usage: %APP_NAME% <sub-command>
echo   config: to generate configuration file or show content.
echo   start: to start the agent as service.
echo   stop: to stop the running service.
echo   update: to update the version.
