#!/usr/bin/env bash

# USAGE: npm run release [version]
# If version isn't specified then minor part (Major.Minor.Fix) will be incremented by default

set -e
newVersion=""

script_dir=$(dirname "$0");
source "$script_dir/package-version.sh"

if [[ $1 ]]; then
  echo "Release argument passed as - ${1}"
else
  echo "Semver release argument requires"
  exit 1
fi

git checkout develop
git pull origin develop --no-edit
git checkout master
git pull origin master --no-edit

version=$(npm version ${1} --no-git-tag-version --allow-same-version)
newVersion="${version//v}"

git add package.json package-lock.json
git stash

getNewAndOldVersions

echo "Version will be update to - ${newVersion}"
read -n 1 -s -r -p "Press any key to continue"

git flow release start $newVersion
git stash apply
git add package.json package-lock.json
git commit -m "Version update $newVersion"
git flow release finish $newVersion

git status
git checkout master
git status

#git push origin develop
#git push origin master

npm ci
npm run build:prod
git add -f dist/
git reset HEAD dist/br.json
git stash

git checkout build
git pull origin build --no-edit
rm -rf dist/
git add dist/
git stash apply
delUnused # TODO: rm: невозможно удалить 'dist/br.json': Нет такого файла или каталога
git commit -m "New build $newVersion"
#git push origin build

echo "Done. Please, check EVERYTHING =) manually and then push the changes. Branches affected: develop, master, build."
