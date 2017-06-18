#!/bin/bash

# continously wait for a stream

STREAM_URL="http://melchior.magi.blue:8000/mpd.ogg"
MPV_OPTS="--no-cache --cache-pause --really-quiet --loop=no --stream-lavf-o=timeout=1"

while true ; do
    # check if a song is playing
    if mpc | grep playing ; then
        echo "Stream is playing!"
        # if so connect to the stream
        mpv $MPV_OPTS $STREAM_URL
        echo "Stream stopped!"
    fi
    if mpc | grep playing ; then
        continue
    fi
    echo "Waiting for mpd state change..."
    # wait for an event
    while ! timeout 10 mpc idle player; do
        continue
    done    
    echo "Stream state changed..."
done
