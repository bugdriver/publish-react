#!/bin/sh -l

SERVER_REPO=$1
REACT_REPO=$2
HEROKU_API_KEY=$3
HEROKU_APP_NAME=$4
GIT_USER_EMAIL=$5
GIT_USER_NAME=$6
exports HEROKU_API_KEY=$HEROKU_API_KEY

git clone https://github.com/${SERVER_REPO}.git

cd $SERVER_REPO

npm install
npm test
cd ..
git clone https://github.com/${REACT_REPO}.git

cd $REACT_REPO
npm install
npm run-script build
cd ..
rm -rf ./$SERVER_REPO/public/*
mv $REACT_REPO/build/* ./$SERVER_REPO/public/
rm -rf $REACT_REPO
cd $SERVER_REPO
git config --global user.email $GIT_USER_EMAIL 
git config --global user.name $GIT_USER_NAME
git add .
git commit -m "added build"
heroku container:login
git remote add heroku https://heroku:${HEROKU_API_KEY}@git.heroku.com/${HEROKU_APP_NAME}.git
git push heroku HEAD:master -f

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"