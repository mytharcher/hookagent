#!/bin/bash

LOG_PATH=/var/log/hookagent
PROJECT=$1
TEMP_FLAG=$LOG_PATH/.$PROJECT

if [[ ! -f $TEMP_FLAG ]]; then
	touch $TEMP_FLAG
else
	exit
fi

branch=$2
task=$3

found=0

git fetch origin
git reset --hard HEAD

for br in $(git branch | sed 's/^[\* ]*//')
do
	if [[ $br == $branch ]]; then
		found=1
	fi
done

if [[ $found == 1 ]]; then
	git checkout $branch
	git merge origin/$branch
else
	git checkout origin/$branch -b $branch
fi

if [[ $task != '' ]]; then
	$task
fi

rm $TEMP_FLAG
