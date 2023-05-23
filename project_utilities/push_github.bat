@echo off
cd ..
set /p name=Commit description: 
git remote add origin https://github.com/CzrCraft/ANONYM.git
git config core.ignorecase false
git pull
git reset
git add .
echo These are the files that are going to be pushed
call git status
set /p temp_var=Continue?(CTRL + C to cancel)
git commit -m "%name%"
git push origin main