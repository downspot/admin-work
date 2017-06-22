#!/bin/sh

email="email@example.com"

function runtest {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Script failed with error from '$@'" | mail -s "Script failure!" $email
        exit 0
    fi
    return $status
}

runtest command
