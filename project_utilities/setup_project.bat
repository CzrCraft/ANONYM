@echo off
cd ..
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
echo        -Installing API depenencies..-
cd api
npm install
cd ..
echo        -Install APP/Flutter dependencies-
cd App
flutter pub get
echo Restart VSCode if it's open!