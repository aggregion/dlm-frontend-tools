#!/usr/bin/env bash

# USAGE: npm run release [version]
# If version isn't specified then minor part (Major.Minor.Fix) will be incremented by default

set -e

script_dir=$(dirname `readlink -f $0`);
source "$script_dir/package-version.sh"

oldVersion=""

git checkout master
git pull origin master --no-edit

getNewAndOldVersions

npm ci
npm run build:prod
git add -f dist/
git stash

git checkout build
git pull origin build --no-edit
rm -rf dist/
git add dist/
git stash apply
delUnused
git commit -m "New build $oldVersion"
#git push origin build

echo "Done. Please, check EVERYTHING =) manually and then push the changes. Branches affected: develop, master, build."
