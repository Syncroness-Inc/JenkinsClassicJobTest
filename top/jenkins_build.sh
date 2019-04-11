#!/bin/bash

# Build script
# usage: jenkins_build.sh [git <branch>]

# get the CWD
CWD=`pwd`

# Calculate build number
MASTER_COUNT=`git rev-list --count origin/master`
DEVELOP_COUNT=`git rev-list --count origin/develop`
BLDNUM=$((MASTER_COUNT + DEVELOP_COUNT))
echo BuildNumber=$BLDNUM > build_number_$BLDNUM.txt

# tag my GIT build
if [ "$1" == "git" ]; then
  source ~/credentials.sh
  echo "source status: $?."
  cat ~/credentials.sh | grep GIT
  whoami
  echo user=$GITHUB_USERNAME
  BRANCHNAME=$2
  export GIT_ASKPASS="top/git-credential-helper.sh"
  TAG=$BRANCHNAME-bldnum-$BLDNUM
  echo "build tag=$TAG" >> build_number_$BLDNUM.txt
  git log --max-count=1 >> build_number_$BLDNUM.txt
  git tag $TAG
  if [ $? -ne 0 ]; then
    git tag -d $TAG
    git tag $TAG
  fi
  set -e
  git push origin $TAG
fi

# Turn on auto-exit-on-error
set -e

# Run the unittests
python3 -m pytest --cov src -v --junitxml junit.xml --cov-report xml tests

# Perform the type checking
python3 -m mypy --config-file top/mypy.ini src
			    
# Run the linter
python3 -m pylint --rcfile=top/pylint.conf src
