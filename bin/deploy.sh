#!/bin/bash

LOG_PATH=/var/log/hookagent
PROJECT=$1
TEMP_FLAG=$LOG_PATH/.$PROJECT

if [[ ! -f $TEMP_FLAG ]]; then
	touch $TEMP_FLAG
else
	exit 0
fi

branch=$2
task=$3

found=0

echo "git reset --hard HEAD"
git reset --hard HEAD
echo "git fetch origin"
git fetch origin

for br in $(git branch | sed 's/^[\* ]*//')
do
	if [[ $br == $branch ]]; then
		echo "found branch: $branch"
		found=1
	fi
done

if [[ $found == 1 ]]; then
	echo "git checkout $branch"
	git checkout $branch
	echo "git merge origin/$branch"
	git merge origin/$branch
else
	echo "git checkout origin/$branch -b $branch"
	git checkout origin/$branch -b $branch
fi

git submodule update --init --recursive

if [[ $task != '' ]]; then
	"$task"
	$task
fi

rm $TEMP_FLAG
