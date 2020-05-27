#!/bin/bash

if [ ! -d /source/.git ]; then
  git clone $REPO /source
fi

cd /source
git stash
git checkout $BRANCH
git reset --hard
git pull origin $BRANCH
git stash pop
cd -

