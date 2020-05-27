#!/bin/bash

# Pull newest code, and reflect any gem updates

if [ ! -d /source/.git ]; then
  git clone $REPO /source
fi

cd /source
git stash
git checkout $BRANCH
git reset --hard
git pull origin $BRANCH
git stash pop
bundle config set path /vendor
bundle config --local path /vendor
bundle install
cd -

