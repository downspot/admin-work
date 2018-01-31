#!/bin/bash

# Find the absolute path of the java executable
# follow all symlinks (to cover /etc/alternatives/java ...)

jpath=$(readlink -e $(which java))

if [[ "$jpath" != "" ]]; then
    while [[ "$jpath" != "/" ]]; do
        jpath=$(dirname $jpath)
        tryinc="$jpath/include"
        if [[ -d "$tryinc" ]]; then
            echo $jpath
            exit 0
        fi
    done
fi
