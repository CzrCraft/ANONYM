@echo off
cd ..
echo        -Installing API depenencies..-
cd api
call npm install
call npm install nodemon
cd ..
echo        -Install APP/Flutter dependencies-
cd App
call flutter pub get
echo Restart VSCode if it's open!
