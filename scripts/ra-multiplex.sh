#!/bin/bash

set -ex

pidfile=/tmp/ra_mux.pid

if [ -f $pidfile ]; then
    if ! ps -p $(cat $pidfile) > /dev/null; then
        # no longer running, clear the file
        rm $pidfile
    fi
fi

if [ ! -f $pidfile ]; then
    ra-multiplex server & >> $HOME/ra.log
    ra_mux_pid=$!

    echo $ra_mux_pid > $pidfile
fi

# obviously change these paths based on where you installed it or if it's in your path
ra-multiplex client
