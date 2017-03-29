#!/usr/bin/env bash

if ! hugo -t cocoa ; then
    exit 1;
fi

exit 0;
