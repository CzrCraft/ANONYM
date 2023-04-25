@echo off
set /p name=Commit description:
git remote add origin https://github.com/CzrCraft/ANONYM.git
git pull
git add .
git reset HEAD -- api/node_modules
git reset HEAD -- App/build
echo These are the files that are going to be pushed
git diff --name-only --cached
set /p temp_var=Continue?(CTRL + C to cancel)
git commit -m "%name%"
git push origin main