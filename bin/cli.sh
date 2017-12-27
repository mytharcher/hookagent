#!/bin/bash

HOME_PATH=`echo ~`
APP_NAME=hookagent

LIB_PATH="$(dirname $0)/$(dirname $(readlink $0))/.."
SERVER_SCRIPT="$LIB_PATH/server.js"
CONFIG_SOURCE="$LIB_PATH/config.json"
CONFIG_PATH="$HOME_PATH/.hookagent"
CONFIG_TARGET="$CONFIG_PATH/config.json"
LOG_PATH="$CONFIG_PATH/log"

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
			vim $CONFIG_TARGET
		else
			if [[ ! -d $CONFIG_PATH ]]; then
				mkdir -p $CONFIG_PATH && echo "$APP_NAME config folder created at $CONFIG_PATH."
			fi
			if [[ ! -f $CONFIG_TARGET ]]; then
				cp $CONFIG_SOURCE $CONFIG_TARGET && chmod 600 $CONFIG_TARGET && echo "$APP_NAME default configurations generated to $CONFIG_TARGET. You can add your project config as sample in it."
			fi
			if [[ ! -d $LOG_PATH ]]; then
				mkdir -p $LOG_PATH && echo "$APP_NAME log folder created at $LOG_PATH."
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

	update )
		npm update -g hookagent
		;;

	*)
		echo "Usage: $APP_NAME <sub-command>"
		echo "  config: to generate configuration file or show content."
		echo "  start: to start the agent as service."
		echo "  stop: to stop the running service."
		echo "  update: to update the version."
		;;

esac
