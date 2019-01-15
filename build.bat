@echo off
:: Batch file to build my test project

:: Select my compiler tools
c:\compilers\vcvars32-vc14.bat

:: Build my project
cl main.c
