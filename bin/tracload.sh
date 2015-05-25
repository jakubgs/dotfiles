#!/bin/bash

set -e
set -x

scp "$@" hq.codility.net:/tmp/trac

ssh hq.codility.net "cd /tmp/trac && rename -f 's/\.trac//' ./*.trac"
ssh hq.codility.net "sudo /srv/trac/bin/trac-admin /srv/trac/environment wiki load /tmp/trac"
ssh hq.codility.net "rm -fr /tmp/trac/*"
