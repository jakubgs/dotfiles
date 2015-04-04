#!/usr/bin/env python
import os, sys, time, re, logging
try:
    import sh
except ImportException:
    log.info('Failed to import module "sh". Please install it.')

class ContextFilter(logging.Filter):
    def filter(self, record):
        record.c_host = host
        return True

def setup_logging(log_file):
    FORMAT = '%(asctime)s - %(c_host)-17s - %(levelname)s: %(message)s'
    logging.basicConfig(format=FORMAT)

    log = logging.getLogger('backup')
    log.addFilter(ContextFilter())
    log.setLevel(logging.DEBUG)

    fhandler = logging.FileHandler(log_file)
    fhandler.setFormatter(logging.Formatter(FORMAT))
    log.addHandler(fhandler)
    return log

def show_output(line):
    log.info(line)

def check_ping(host):
    r = ping()
    m = re.search(r'time=([^ ]*) ', r.stdout)
    time = float(m.group(1))
    return time

log_file='/var/log/backup.log'
log = setup_logging(log_file)

host = ''
minimal_ping = 6

assets = [
    '/home/jso'
]
targets = [
    { 'user': 'jacob',  'host': 'enpoka',
        'dir': '/home/jacob/backup/' },
    { 'user': 'sochan', 'host': 'melchior',
        'dir': '/mnt/raid1/backup/homes/' }
]

rsync_opts = ''
if os.isatty(sys.stdout.fileno()):
    rsync_opts = '--info=progress2'

for target in targets:
    dest = "{}@{}:{}".format(target['user'], target['host'], target['dir'])
    host = '{}@{}'.format(target['user'], target['host'])

    ssh = sh.ssh.bake('-q', '-o ConnectTimeout=2', host)
    ping = sh.ping.bake(target['host'], '-c1')
    try:
        ssh.exit()
    except Exception as e:
        log.info('Host not available')
        continue

    ping = check_ping(host) 
    if ping > minimal_ping:
        log.warning('Ping or host too slow({}s), abandoning.'.format(ping))
        continue

    for asset in assets:
        log.info("rsync: {} -> {}".format(asset, target['dir']))
        rsync = sh.rsync.bake('-arut', '--delete', rsync_opts,
                              '--exclude=.*', '--exclude=.*/', 
                              asset, dest, _out=show_output)
        try:
            start = time.time()
            rsync_output = rsync()
            end = time.time()
        except Exception as e:
            log.error('Failed to execute command: {}'.format(rsync))
            log.error('Output: {}'.format(host, rsync_output))
            continue
        log.info('Finished in: {}'.format(end - start))
