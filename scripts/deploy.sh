#!/bin/bash

echo "Copying new website into other repo..."

cp -R ./* ../../caramelomartins.github.io/

echo "Push changes to remote..."

cd "../../caramelomartins.github.io/" || exit
git add -A > /dev/null 2>&1
git commit -m "Push new content" > /dev/null 2>&1
git push > /dev/null 2>&1

echo "Finished deployment..."
