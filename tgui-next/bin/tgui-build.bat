@echo off
cd "%~dp0\.."
call yarn install
call yarn run build
pause
