#!/bin/bash

echo "Building website..."

cd .. 
hugo -t cocoa
cd ../public

echo "Copying new website into other repo..."

cp -R ./* ../../caramelomartins.github.io/

echo "Push changes to remote..."

cd "../../caramelomartins.github.io/"
git add -A
git commit -m "Push new content"
git push
