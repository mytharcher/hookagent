#!/bin/bash

LOG_PATH=/var/log/hookagent
PROJECT=$1

remote=$2
branch=$3
task=$4

echo "start deploying $remote/$branch"

TEMP_FLAG=$LOG_PATH/.$PROJECT.$remote-$branch

if [[ ! -f $TEMP_FLAG ]]; then
	touch $TEMP_FLAG
else
	echo "still deploying..."
	exit 0
fi


found=0

pwd

echo "git reset --hard HEAD"
git reset --hard HEAD
echo "git fetch $remote"
git fetch $remote

for br in $(git branch | sed 's/^[\* ]*//')
do
	if [[ $br == $branch ]]; then
		echo "found branch: $branch"
		found=1
	fi
done

if [[ $found == 1 ]]; then
	echo "git checkout -q $branch"
	git checkout -q $branch
	echo "git merge $remote/$branch"
	git merge $remote/$branch
else
	echo "git checkout $remote/$branch -b $branch"
	git checkout $remote/$branch -b $branch
fi

git submodule update --init --recursive

if [[ $task != '' ]]; then
	echo "start to run shell script: $task"
	sh $task
fi

rm $TEMP_FLAG
