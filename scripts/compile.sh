#!/usr/bin/env bash

if ! hugo -v -t cocoa ; then
    exit 1;
fi

exit 0;
