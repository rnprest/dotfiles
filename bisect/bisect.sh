#!/bin/bash

first_commit=$(git rev-list --max-parents=0 HEAD)
echo ${first_commit}

git bisect start HEAD ${first_commit}
git bisect run ./bisect-check.sh
