#!/bin/bash

echo "Cloning caramelomartins.github.io..."
git clone git@github.com:caramelomartins/caramelomartins.github.io.git

echo "Removing contents..."
rm -r caramelomartins.github.io/*

echo "Copying new contents..."
cp -r public/* caramelomartins.github.io/

HASH=$(git rev-parse --short HEAD)
echo "Pushing new contents..."
cd caramelomartins.github.io || exit
git add ./*
git commit -m "Auto Deploy - $HASH" -m "Built from: https://github.com/caramelomartins/website/commit/$HASH." --allow-empty
git push
cd ..

echo "Removing built assets..."
rm -rf caramelomartins.github.io/* caramelomartins.github.io/.git
rmdir caramelomartins.github.io

exit 0;
