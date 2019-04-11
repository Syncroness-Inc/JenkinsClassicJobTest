::@echo off
:: This script is intended to be use by Jenkins to:
::	- Run all unittests (and generate code coverage metrics)
::  - Run pylint
::  - Run mypy  (to enforce type hinting)
::  - Run Doxygen
::
:: The script is assumed to be launched from the root of the repository

:: Get the path to the top/ directory
set TOP_DIR=%~p0

:: Calculate the build number (is the total number of commits acrossed master and develop branches in the Git repo)
set MASTER_COUNT=0
set DEVELOP_COUNT=0
for /f %%i in ('git rev-list --count origin/master') do set MASTER_COUNT=%%i
for /f %%i in ('git rev-list --count origin/develop') do set DEVELOP_COUNT=%%i
set /A BLDNUM=%MASTER_COUNT%+%DEVELOP_COUNT%
echo:BuildNumber=%BLDNUM% > build_number_%BLDNUM%.txt

:: Run the unittests (and generate code coverage metrics)
py -m pytest --cov src -v --junitxml junit.xml --cov-report xml tests
IF ERRORLEVEL 1 exit /b 1

:: Perform the type checking
py -m mypy --config-file top\mypy.ini src
IF ERRORLEVEL 1 exit /b 1

:: Run the linter
py -m pylint  --rcfile=top\pylint.conf src
IF ERRORLEVEL 1 exit /b 1

:: Run doxygen
pushd %TOP_DIR%
run-doxygen.py
IF ERRORLEVEL 1 exit /b 1
popd