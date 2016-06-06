#!/usr/bin/env python
import os, sys, time, re, json, logging, signal, glob, socket, atexit, argparse
try:
    import sh
except ImportError:
    print 'Failed to import module "sh". Please install it.'
    sys.exit(1)


SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))
DEFAULT_CONFIG_FILE = os.path.join(SCRIPT_PATH, 'backup.json')
DEFAULT_PID_FILE = '/tmp/backup.pid'
DEFAULT_LOG_FILE = '/tmp/backup.log'

# time in seconds that the ping response have to be under
DEFAULT_MINIMAL_PING = 5
# time in seconds after which backup process will be stopped
DEFAULT_TIMEOUT = 72000

HELP_MESSAGE = """
This script backups directories configred as 'assets' in the JSON config file.
"""


class TimeoutException(Exception):
    pass

def exit_handler():
    os.remove(DEFAULT_PID_FILE)

def signal_handler(signum, frame):
    raise TimeoutException('Timed out!')

class Target(object):
    def __init__(self, id, user, host, port, dir):
        self.id = id
        self.user = user
        self.host = host
        self.port = port
        self.dir = dir

        # prepare the rsync command
        self.rsync = sh.rsync.bake(archive=True,
                                   recursive=True,
                                   update=True,
                                   times=True,
                                   partial=True,
                                   delete_after=True,
                                   delete_excluded=True,
                                   port=self.port,
                                   _out=show_output)

    @classmethod
    def from_dict(cls, data):
        return cls(
                data['id'],
                data['user'],
                data['host'],
                data['port'],
                data['dir'],
            )
    
    def available(self):
        return self.ping_check() and self.ssh_check()

    def ssh_check(self, timeout=1):
        host_str = '{}@{}'.format(self.user, self.host)

        ssh = sh.ssh.bake(o='ConnectTimeout={}'.format(timeout),
                          F='/dev/null', # ignore configuration
                          q=True,
                          l=self.user,
                          p=self.port)
        ssh = ssh.bake(self.host)
        LOG.debug('CMD: %s', ssh)
        try:
            ssh.exit()
        except Exception as e:
            LOG.info('Host not available: %s', host_str)
            return False
        return True
    
    def ping_check(self, min_ping=DEFAULT_MINIMAL_PING):
        ping = sh.ping.bake(self.host, '-c1')
        LOG.debug('CMD: %s', ping)
        try:
            r = ping()
        except Exception as e:
            return False
        m = re.search(r'time=([^ ]*) ', r.stdout)
        time = float(m.group(1))
        if time > min_ping:
            LOG.warning('Ping or host too slow({}s), abandoning.'.format(ping))
            return False
        return True

    def sync(self, asset, timeout=DEFAULT_TIMEOUT):
        dest_full = '{}@{}:{}'.format(self.user, self.host,
                                      os.path.join(self.dir, asset['dest']))
        rsync_full = self.rsync.bake(asset['src'], dest_full)
        # bake in additional options for asset
        if len(asset['opts']) > 0:
            rsync_full = self.rsync.bake(asset['opts'])
        if len(asset['exclude']) > 0:
            for entry in asset['exclude']:
                rsync_full = self.rsync.bake(exclude=entry)

        LOG.info('Starting rsync: %s -> %s', asset['src'], dest_full)
        LOG.debug('CMD: %s', rsync_full)

        # prepare timer to kill command if it runs too long
        signal.signal(signal.SIGALRM, signal_handler)
        signal.alarm(timeout)
        LOG.debug('Command timeout: %s', timeout)
        try:
            start = time.time()
            rsync_output = rsync_full()
            end = time.time()
        except TimeoutException as e:
            LOG.error('Rsync timed out after {} seconds!'.format(timeout))
            return None
        except Exception as e:
            LOG.error('Failed to execute command: %s', rsync_full)
            LOG.error('Output: {}'.format(e.stderr or rsync_output.stderr))
            return None

        LOG.info('Finished in: {}'.format(end - start))
        return rsync_output

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

def setup_logging(log_file, debug):
    FORMAT = '%(asctime)s - %(c_host)21s - %(levelname)s: %(message)s'
    logging.basicConfig(format=FORMAT)

    log = logging.getLogger('backup')
    if debug:
        log.setLevel(logging.DEBUG)
    else:
        log.setLevel(logging.INFO)

    class ContextFilter(logging.Filter):
        def filter(self, record):
            global host_str
            if host_str == '':
                record.c_host = socket.gethostname()
            else:
                record.c_host = host_str
            return True

    log.addFilter(ContextFilter())

    fhandler = logging.FileHandler(log_file)
    fhandler.setFormatter(logging.Formatter(FORMAT))
    log.addHandler(fhandler)
    return log

def show_output(line):
    print line

# TODO check connection speed, not just the ping
# TODO check when did the last backup happen
# TODO make backup despite bad connection if last backup is old

def check_process(pid_file):
    if os.path.isfile(pid_file):
        pid = None
        with open(pid_file, 'r') as f:
            pid = f.read()
        if proc_exists(pid):
            return True, True
        else:
            return True, False

    else:
        with open(pid_file, 'w') as f:
            f.write(str(os.getpid())[:-1])
        return False, False

def verify_process_is_alone(pid_file=DEFAULT_PID_FILE):
    atexit.register(exit_handler)
    file_is, process_is = check_process(pid_file)
    if file_is and process_is:
        log.warning('Process already in progress: {} ({})'.format(pid, pid_file))
        sys.exit(0)
    elif file_is and not process_is:
        log.warning('Pid file process is dead: {} ({})'.format(pid, pid_file))
        if args.force:
            log.warning('Removing: {}'.format(pid_file))
            exit_handler()
        else:
            sys.exit(0)

def read_config_file(config_file=DEFAULT_CONFIG_FILE):
    with open(config_file, 'r') as f:
        return json.load(f)

def set_host(new_host_str=None):
    # this is for nice logging
    global host_str
    host_str = new_host_str or '{}@{}'.format(os.getlogin(), socket.gethostname())

def create_arguments():
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, 
                                     description=HELP_MESSAGE)

    parser.add_argument("-a", "--assets", nargs='+', type=str, default=DEFAULT_PID_FILE,
                        help="List of assets to process.")
    parser.add_argument("-t", "--timeout", type=int, default=DEFAULT_TIMEOUT,
                        help="Time after which rsync command will be stopped.")
    parser.add_argument("-p", "--pid-file", type=str, default=DEFAULT_PID_FILE,
                        help="Location of the PID file.")
    parser.add_argument("-l", "--log-file", type=str, default=DEFAULT_LOG_FILE,
                        help="Location of the log file.")
    parser.add_argument("-c", "--config", type=str, default=DEFAULT_CONFIG_FILE,
                        help="Location of JSON config file.")
    parser.add_argument("-o", "--one-instance", action='store_true',
                        help="Check if there is another instance running.")
    parser.add_argument("-d", "--debug", action='store_true',
                        help="Enable debug logging.")
    parser.add_argument("-b", "--battery-check", action='store_true',
                        help="Enable checking for battery power before running.")
    parser.add_argument("-f", "--force", action='store_true',
                        help="When used things like running on battery are ignored.")
    return parser.parse_args()

def main():
    set_host()
    opts = create_arguments()
    global LOG
    LOG = setup_logging(opts.log_file, opts.debug)
    conf = read_config_file(opts.config)

    if opts.one_instance:
        verify_process_is_alone(opts.pid_file)

    if opts.battery_check and not opts.force and on_battery():
        LOG.warning('System running on battery. Aborting.')
        sys.exit(0)

    targets = dict()
    for target in conf['targets'].itervalues():
        targets[target['id']] = Target.from_dict(target)

    for asset in conf['assets'].itervalues():
        target = targets[asset['target']]
        set_host('{}@{}'.format(target.user, target.host))

        if not target.available() and not opts.force:
            LOG.error('Skipping asset: %s', asset['id'])
            continue

        output = target.sync(asset, opts.timeout)

if __name__ == "__main__":
    main()
