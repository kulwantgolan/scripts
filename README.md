# HELPFUL SCRIPTS

## Category: GIT
### DESC: Copy current local folder to github repo
 
```
export GITHUB_PAT="🐍YOUR_PAT_HERE"
mkdir -p scripts && curl -fsSL https://raw.githubusercontent.com/kulwantgolan/scripts/main/git_prepare_and_push.sh -o scripts/git_prepare_and_push.sh
cp scripts/git_prepare_and_push.sh git_prepare_and_push.sh
chmod +x git_prepare_and_push.sh
./git_prepare_and_push.sh 🐍GIT_REPO_NAME
```
### DESC: Follow-on push
```
git add -A
git commit -m "🐍DESC OF COMMIT HERE"
# git branch -M main
# git remote add origin https://github.com/kulwantgolan/🐍GIT_REPO_HERE.git
git push -u origin main
```
