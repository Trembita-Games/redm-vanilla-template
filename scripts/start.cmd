@echo off

cd /d %~dp0\..

if not exist server\FXServer.exe (
    echo [ERROR] FXServer executable is missing.
    echo Please download and extract FXServer artifacts into the "server" directory.
    pause
    exit /b 1
)

server\FXServer.exe +exec server.cfg