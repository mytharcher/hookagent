#!/bin/bash

branch=$1
task=$2

found=0

git fetch origin
git reset --hard HEAD

for br in $(git branch | sed 's/^[\* ]*//')
do
	if [[ $br=$branch ]]; then
		found=1
	fi
done

if [[ $found=1 ]]; then
	git checkout $branch
	git merge origin/$branch
else
	git checkout origin/$branch -b $branch
fi

if [[ $task ]]; then
	$task
fi