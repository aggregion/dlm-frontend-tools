#!/usr/bin/env bash
newPackageName=temporaryFileForNewPackage.json

function delUnused() {
  if [[ -f "dist/br.json" ]];
  then
    rm dist/br.json
  fi

  if [[ -d src ]];
  then
    rm -r src
  fi
}

function getNewAndOldVersions() {
  versionString=`cat package.json | grep \"version\"`

  if [[ $versionString =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    echo "Old version is ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
    oldVersion=${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}
  else
    echo "ERROR: unable to parse version from ./package.json"
    exit 1
  fi
}

function updatePackageJsonWithNewVersion() {
  echo "Creating temporary package.json with updated version field: $newPackageName"

  cat package.json | while IFS='' read -r line || [[ -n "$line" ]]; do
    if [[ $line =~ (.*\"version\".*)([0-9]+\.[0-9]+\.[0-9]+)(.*) ]]; then
      line="${BASH_REMATCH[1]}$1${BASH_REMATCH[3]}"
    fi

    echo "$line" >> "$newPackageName"
  done

  echo "Removing package.json"
  rm package.json

  echo -e "Renaming $newPackageName to package.json\n"
  mv "$newPackageName" package.json
}
