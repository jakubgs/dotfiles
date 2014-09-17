#!/bin/bash

# continously wait for a stream

STREAM_URL="http://nerv.no-ip.org:8000/mpd.ogg"

while true ; do
    # check if a song is playing
    if mpc | grep playing ; then
        echo "Stream is playing!"
        # if so connect to the stream
        mpv --no-cache --quiet $STREAM_URL
    fi
    echo "Waiting for mpd state change..."
    # wait for an event
    mpc idle player
    echo "Stream state changed..."
done
