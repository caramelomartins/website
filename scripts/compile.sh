#!/usr/bin/env bash

echo "Compiling website..."

if ! hugo -t cocoa ; then
    echo "Building website failed."
    exit 1;
fi

echo "Built website successfuly."
exit 0;
