#!/bin/bash
set -e

PROJECT_DIRECTORY="javascript"
SITE_DIRECTORY="$PROJECT_DIRECTORY-site"
GITHUB_REPO="git@github.com:tajo/javascript.git"
GH_PAGES_SITE="http://tajo.github.io/javascript/"
CUSTOM_DOMAIN="http://www.dzejes.cz"

# Move to parent dir
cd ../

# Setup repo if doesnt exist
if [ ! -d "$SITE_DIRECTORY" ]; then
  read -p "No site repo setup, can I create it at \"$PWD/$SITE_DIRECTORY\"? [Y/n] " -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! $REPLY == "" ]]
  then
    echo "Exit by user"
    exit 1
  fi
  git clone "$GITHUB_REPO" "$SITE_DIRECTORY"
  cd "$SITE_DIRECTORY"
  git checkout origin/gh-pages
  git checkout -b gh-pages
  git push --set-upstream origin gh-pages
  cd ../
fi

cd "$PROJECT_DIRECTORY"
npm run build-site
echo "$CUSTOM_DOMAIN" >> __site__/CNAME
cp site/logo.png __site__/logo.png
cp site/feed.xml __site__/feed.xml
cp site/_config.yml __site__/_config.yml
open __site__/index.html
cd ../

echo
echo
read -p "Are you ready to publish? [Y/n] " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] && [[ ! $REPLY == "" ]]
then
  echo "Exit by user"
  exit 1
fi

cd "$SITE_DIRECTORY"
git reset --hard
git checkout -- .
git clean -dfx
git fetch
git rebase
rm -Rf *
echo "$PWD"
cp -R ../$PROJECT_DIRECTORY/__site__/* .
git add --all
git commit -m "Update website"
git push
sleep 1
open $CUSTOM_DOMAIN
