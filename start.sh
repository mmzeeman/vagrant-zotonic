#!/bin/bash

if [ ! -d zotonic ]; then
    # Clone the zotonic repo you are working on.
    git clone git@github.com:mmzeeman/zotonic.git
fi

## If needed, add your own-repositories here.

vagrant up
