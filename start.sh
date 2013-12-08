#!/bin/bash

if [ ! -d zotonic ]; then
    git clone git@github.com:mmzeeman/zotonic.git
    cd zotonic; git checkout elli_machine; cd ..
fi

## Add your own-repositories here.

vagrant up
