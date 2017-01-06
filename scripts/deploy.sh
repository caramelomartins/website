#!/bin/bash

echo "Building website..."

cd "../public"
hugo -t cocoa

echo "Copying new website into other repo..."

rm -r ../../caramelomartins.github.io/*
cp -R ./* ../../caramelomartins.github.io/

echo "Push changes to remote..."
git add -A
git commit -m "Push new content"
git push
