#!/usr/bin/env python
import os, sys, time, re, logging, signal
try:
    import sh
except ImportException:
    print 'Failed to import module "sh". Please install it.'
    sys.exit(1)

class TimeoutException(Exception):
    pass

def signal_handler(signum, frame):
    raise TimeoutException('Timed out!')

class ContextFilter(logging.Filter):
    def filter(self, record):
        record.c_host = host
        return True

def setup_logging(log_file):
    FORMAT = '%(asctime)s - %(c_host)21s - %(levelname)s: %(message)s'
    logging.basicConfig(format=FORMAT)

    log = logging.getLogger('backup')
    log.addFilter(ContextFilter())
    log.setLevel(logging.DEBUG)

    fhandler = logging.FileHandler(log_file)
    fhandler.setFormatter(logging.Formatter(FORMAT))
    log.addHandler(fhandler)
    return log

def show_output(line):
    print line

def check_ping(host):
    r = ping()
    m = re.search(r'time=([^ ]*) ', r.stdout)
    time = float(m.group(1))
    return time

log_file='/var/log/backup.log'
log = setup_logging(log_file)

host = ''
minimal_ping = 6
# time in seconds after which backup process will be stopped
timeout = 300

assets = [
    '/home/jso'
]
targets = [
    { 'user': 'jacob',  'host': 'enpoka', 'port': '22',
        'dir': '/home/jacob/backup/' },
    { 'user': 'sochan', 'host': 'nerv.no-ip.org', 'port': '6666',
        'dir': '/mnt/raid1/backup/homes/' }
]

rsync_opts = ''
if os.isatty(sys.stdout.fileno()):
    rsync_opts = '--info=progress2'

# TODO check connection speed, not just the ping
# TODO check if laptop is on battery
# TODO check when did the last backup happen
# TODO make backup despite bad connection if last backup is old
# TODO possibly add a backup timeout

for target in targets:
    dest = "{}@{}:{}".format(target['user'], target['host'], target['dir'])
    host = '{}@{}'.format(target['user'], target['host'])

    ssh = sh.ssh.bake('-q', '-o ConnectTimeout=2', '-p '+target['port'], host)
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
                              '-e ssh -p {}'.format(target['port']),
                              '--exclude=.*', '--exclude=.*/', 
                              asset, dest, _out=show_output)

        signal.signal(signal.SIGALRM, signal_handler)
        signal.alarm(timeout)
        try:
            start = time.time()
            rsync_output = rsync()
            end = time.time()
        except TimeoutException as e:
            log.error('Rsync timed out after {} seconds!'.format(timeout))
            sys.exit(1)
        except Exception as e:
            log.error('Failed to execute command: {}'.format(rsync))
            log.error('Output: {}'.format(e.stderr or rsync_output.stderr))
            continue
        log.info('Finished in: {}'.format(end - start))
