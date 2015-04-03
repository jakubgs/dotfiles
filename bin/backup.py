#!/usr/bin/env python
import os, sys, time
try:
    import sh
except ImportException:
    print 'Failed to import module "sh". Please install it.'

def show_output(line):
    print line

log_file = '/var/log/backup.log'

assets = [
    '/home/jso'
]
targets = [
    { 'user': 'jacob',  'host': 'enpoka',   'dir': '/home/jacob/backup/' },
    { 'user': 'sochan', 'host': 'melchior', 'dir': '/mnt/raid1/backup/homes/' }
]

rsync_opts = ''
if os.isatty(sys.stdout.fileno()):
    rsync_opts = '--info=progress2'

for target in targets:
    dest = "{}@{}:{}".format(target['user'], target['host'], target['dir'])
    host = '{}@{}'.format(target['user'], target['host'])

    ssh = sh.ssh.bake('-q', host)
    try:
        ssh.exit()
    except Exception as e:
        print 'Host not available: {}'.format(host)
        continue

    for asset in assets:
        print "rsync: {} -> {}".format(asset, dest)
        rsync = sh.rsync.bake('-arut', '--delete', rsync_opts,
                              '--exclude=.*', '--exclude=.*/', 
                              asset, dest, _out=show_output)
        try:
            start = time.time()
            rsync_output = rsync()
            end = time.time()
        except Exception as e:
            print 'Failed to execute command: {}'.format(rsync)
            print 'Output: {}'.format(rsync_output)
            continue
        print 'Finished in: {}'.format(end - start)
