#!/usr/bin/env python
import os, sys, time, re
try:
    import sh
except ImportException:
    print 'Failed to import module "sh". Please install it.'

def show_output(line):
    print line

def slow_ping(host):
    r = ping()
    m = re.search(r'time=([^ ]*) ', r.stdout)
    time = float(m.group(1))
    if time > minimal_ping:
        return True
    return False

minimal_ping = 6
log_file = '/var/log/backup.log'

assets = [
    '/home/jso'
]
targets = [
    { 'user': 'jacob',  'host': 'enpoka',
        'dir': '/home/jacob/backup/' },
    { 'user': 'sochan', 'host': 'nerv.no-ip.org',
        'dir': '/mnt/raid1/backup/homes/' }
]

rsync_opts = ''
if os.isatty(sys.stdout.fileno()):
    rsync_opts = '--info=progress2'

for target in targets:
    dest = "{}@{}:{}".format(target['user'], target['host'], target['dir'])
    host = '{}@{}'.format(target['user'], target['host'])

    ssh = sh.ssh.bake('-q', host)
    ping = sh.ping.bake(target['host'], '-c1')
    try:
        ssh.exit()
    except Exception as e:
        print 'Host not available: {}'.format(host)
        continue

    if slow_ping(host):
        print 'Ping or host too slow, abandoning: {}'.format(host)
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
