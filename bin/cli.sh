#!/bin/bash

APP_NAME=hookagent

LIB_PATH="$(dirname $0)/$(dirname $(readlink $0))/.."
SERVER_SCRIPT="$LIB_PATH/server.js"
CONFIG_SOURCE="$LIB_PATH/config.json"
CONFIG_TARGET="/etc/$APP_NAME.json"
LOG_PATH="/var/log/$APP_NAME"

CONFIGURED=0

if [[ -f $CONFIG_TARGET && -d $LOG_PATH ]]; then
	CONFIGURED=1
fi

check_config() {
	if [[ $CONFIGURED = 0 ]]; then
		echo "No config found as $CONFIG_SOURCE. Please run '$APP_NAME config' first to generate default config."
	fi
}

case $1 in
	config )
		if [[ $CONFIGURED = 1 ]]; then
			echo "$APP_NAME configurations ($CONFIG_TARGET):"
			cat $CONFIG_TARGET
		else
			if [[ ! -f $CONFIG_TARGET ]]; then
				cp $CONFIG_SOURCE $CONFIG_TARGET && chmod 600 $CONFIG_TARGET && echo "$APP_NAME default configurations generated to $CONFIG_TARGET. You can add your project config as sample in it."
			fi
			if [[ ! -d $LOG_PATH ]]; then
				mkdir -p $LOG_PATH -m 777 && echo "$APP_NAME log folder created at $LOG_PATH."
			fi
		fi
		;;
	start )
		if [[ $CONFIGURED = 1 ]]; then
			echo "Starting deploy agent server..."
			pm2 start $SERVER_SCRIPT --name $APP_NAME
		else
			check_config
		fi
		;;
	stop )
		if [[ $CONFIGURED = 1 ]]; then
			echo "Stopping deploy agent server..."
			pm2 stop $APP_NAME
		fi
		;;
	restart )
		if [[ $CONFIGURED = 1 ]]; then
			echo "Restarting deploy agent server..."
			pm2 restart $APP_NAME
		else
			check_config
		fi
		;;
	*)
		echo "Usage: $APP_NAME <sub-command>"
		echo "  config: to generate configuration file or show content."
		echo "  start: to start the agent as service."
		echo "  stop: to stop the running service."
		;;
esac
