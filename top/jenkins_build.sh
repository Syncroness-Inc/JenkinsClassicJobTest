#!/bin/bash

# Build script

# Calculate build number
MASTER_COUNT=`git rev-list --count origin/master`
DEVELOP_COUNT=`git rev-list --count origin/develop`
BLDNUM=$((MASTER_COUNT + DEVELOP_COUNT))
echo "BuildNumber=$BLDNUM" > build_number_$BLDNUM.txt

# Turn on auto-exit-on-error
set -e

# Run the unittests
python3 -m pytest --cov src -v --junitxml junit.xml --cov-report xml tests

# Perform the type checking
python3 -m mypy--config-file top/mypy.ini src

# Run the linter
python3 -m pyline --rcfile=top/pylint.conf src
