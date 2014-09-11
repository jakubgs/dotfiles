#!/bin/bash

# continously wait for a stream

STREAM_URL="http://nerv.no-ip.org:8000/mpd.ogg"

while true ; do
    # check if a song is playing
    if mpc | grep playing ; then
        # if so connect to the stream
        mpv --no-cache $STREAM_URL
    fi
    # wait for an event
    mpc idle player
done
