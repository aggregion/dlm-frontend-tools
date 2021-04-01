## Requirements

* Install git flow `$ sudo apt-get install git-flow`
* Init git flow `$ git flow init`  
releases: [master]  
development: [develop]  
Feature branches? [feature/]  
Bugfix branches? [bugfix/]  
Release branches? [release/]  
Hotfix branches? [hotfix/]  
Support branches? [support/]  

## Build and release
You can use this package for convenient one-command build and release making.
First of all install this package globally

`npm i -g git+ssh://git@stash.aggregion.com:7999/frt/frontend-tools.git`

Or

`git clone ssh://git@stash.aggregion.com:7999/frt/frontend-tools.git`
`npm i -g ./frontend-tools`

Then commands `aggr-build` and `aggr-release` will be available for you

`aggr-build` will make a build based on `master` branch (useful after hotfix).


### aggr-release
`aggr-release` requires an argument to specify release type as a `semver`.
`aggr-release` wraps npm-version to detect release type https://docs.npmjs.com/cli/version
`aggr-release` will run `git flow release` and build app afterwards.

```
aggr-release major
```

### Manual version increasing
If you want to increase version manually run `aggr-release <version>`

```
aggr-release 1.2.3
```

#### Here is the requirements for project structure:

* It's a `git flow` and `npm` based repo (git flow command also must be accessible)
* Build is placed in the distinct `build branch` in the `dist folder`
* `dist folder` is in `.gitignore` for other branches
* Build generating command must be a `npm run build:prod`

### After release
`$ git push origin develop`  
`$ git push origin master`  
`$ git push origin build`  
`$ git push --tags`  -- if you need to

### Warning
* It will remove your current build (in `dist folder`)
* Remove and recreate `package.json` file
* And perform `npm ci`
