#!/usr/bin/env python
import os, sys, time, re, logging, signal, glob, socket, atexit, argparse
try:
    import sh
except ImportException:
    print 'Failed to import module "sh". Please install it.'
    sys.exit(1)

class TimeoutException(Exception):
    pass

def exit_handler():
    os.remove(pid_file)

def signal_handler(signum, frame):
    raise TimeoutException('Timed out!')

class ContextFilter(logging.Filter):
    def filter(self, record):
        if host == '':
            record.c_host = socket.gethostname()
        else:
            record.c_host = host
        return True

def on_battery():
    for bat_stat_file in glob.glob('/sys/class/power_supply/BAT*/status'):
        with open(bat_stat_file) as f:
            if f.read().rstrip()== 'Discharging':
                return True

def proc_exists(pid):
    try:
        os.kill(pid, 0)
    except Exception as e:
        return False
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
    if args.force:
        return
    ping = sh.ping.bake(target['host'], '-c1')
    try:
        r = ping()
    except Exception as e:
        # failed ping does not mean host is unavailable
        return
    m = re.search(r'time=([^ ]*) ', r.stdout)
    time = float(m.group(1))
    if ping > minimal_ping:
        log.warning('Ping or host too slow({}s), abandoning.'.format(ping))
        return os.exit(1)

pid_file='/run/backup/backup.pid'
log_file='/var/log/backup.log'
log = setup_logging(log_file)

host = ''
minimal_ping = 6
# time in seconds after which backup process will be stopped
timeout = 120

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

HELP_MESSAGE = '''
This script backups following directories:

 * {}
'''.rstrip().format('\n * '.join(assets))

parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, 
                                 description=HELP_MESSAGE)
# options for setting locations
parser.add_argument("--force", action='store_true',
                    help="When used things like running on battery are ignored.")
args = parser.parse_args()

# TODO check connection speed, not just the ping
# TODO check when did the last backup happen
# TODO make backup despite bad connection if last backup is old

if on_battery() and not args.force:
    log.warning('System running on battery. Aborting.')
    sys.exit(0)

if os.path.isfile(pid_file):
    pid = None
    with open(pid_file, 'r') as f:
        pid = f.read()
    if proc_exists(pid):
        log.warning('Process already in progress: {} ({})'.format(pid, pid_file))
        sys.exit(0)
    else:
        log.warning('Pid file process is dead: {} ({})'.format(pid, pid_file))
        if args.force:
            log.warning('Removing: {}'.format(pid_file))
            exit_handler()
        else:
            sys.exit(0)

else:
    with open(pid_file, 'w') as f:
        f.write(str(os.getpid())[:-1])

atexit.register(exit_handler)

for target in targets:
    dest = "{}@{}:{}".format(target['user'], target['host'], target['dir'])
    host = '{}@{}'.format(target['user'], target['host'])

    ssh = sh.ssh.bake('-q', '-o ConnectTimeout=2', '-p '+target['port'], host)
    try:
        ssh.exit()
    except Exception as e:
        log.info('Host not available')
        continue

    check_ping(host) 

    for asset in assets:
        log.info("rsync: {} -> {}".format(asset, target['dir']))
        rsync = sh.rsync.bake('-arut', rsync_opts,
                              '--delete', '--delete-excluded',
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
