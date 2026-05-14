@echo off

cd /d %~dp0\..

if not exist server (
    echo [ERROR] FXServer artifacts are missing.
    echo Please download and extract FXServer artifacts into the "server" directory.
    pause
    exit /b 1
)

cd server

FXServer.exe +exec ../server.cfg