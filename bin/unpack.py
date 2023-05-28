#!/usr/bin/env python3
import os
import re
import sys
import glob
import shutil
import logging
import argparse

try:
    import sh
except ImportError as ex:
    print('Missing required Python 3 module: sh')
    print('URL: https://pypi.python.org/pypi/sh')
    print('To install run:')
    print('sudo pip3 install sh')
    sys.exit(1)

HELP_MESSAGE='''
This script is intended for mass unpacking of directories.
'''.strip()

ARCH_CMDS = {
    r'.*\.(tar\.gz|tgz)':       lambda f,d: sh.tar.bake('xvzf')(f, C=d),
    r'.*\.(tar.bz2|tbz2|tbz)':  lambda f,d: sh.tar.bake('xvjf')(f, C=d),
    r'.*\.(zip)':               lambda f,d: sh.unzip.bake()(o=f, d=d),
    r'.*\.(rar)':               lambda f,d: sh.unrar.bake('x -o- -ad')(f),
    r'.*\.(7z)':                lambda f,d: sh('7z').bake('x -y')(f, o=d),
    r'.*\.(zsh)':               lambda f,d: sh.lha.bake('e')(f, w=d),
}

def unpack(filename, overwrite=False):
    for regex, cmd in ARCH_CMDS.items():
        basename, ext = os.path.splitext(filename)

        matches = re.findall(regex, filename)

        if len(matches) == 0:
            continue

        if os.path.isdir(basename) and not overwrite:
            LOG.info('SKIP - Exists: %s', basename)
            return None

        LOG.info('Unpacking: %s -> %s', filename, basename)
        rval = cmd(filename, basename)
        LOG.info(rval.stdout)
        LOG.error(rval.stderr)
        return basename
    
    LOG.info('SKIP - Unknown file extension: %s', ext)
    return None


def cleanup(unpacked):
    LOG.info('Cleanup: %s', unpacked)
    contents = gob.glob('{}/*'.format(unpacked))

    if len(contents) == 1:
        LOG.info(' * Removing useless dir: %s', contents[0])
        for filename in glob.glob('{}/*', contents[0]):
            shutil.move(filename, unpacked)


def parse_opts():
    parser = argparse.ArgumentParser(
                formatter_class=argparse.RawDescriptionHelpFormatter, 
                description=HELP_MESSAGE
            )
    parser.add_argument('glob', nargs='?', type=str, default='*',
                        help='Glob patterns to find files to unpack.')
    parser.add_argument('-o', '--overwrite', action='store_true',
                        help='Unpack again even if dir exists.')
    parser.add_argument('-c', '--cleanup', action='store_true',
                        help='Clean inside of upaced dirs by removing depth.')
    parser.add_argument('-t', '--timestamps', action='store_true',
                        help='Show timestmaps for log messages.')
    parser.add_argument('-d', '--debug', action='store_true',
                        help='Enable debug messages.')
    return parser.parse_args()


def setup_logging(debug, timestamps=False):
    FORMAT = '%(levelname)s: %(message)s'
    if timestamps:
        FORMAT = '%(asctime)s - ' + FORMAT

    logging.basicConfig(format=FORMAT)

    log = logging.getLogger()
    if debug:
        log.setLevel(logging.DEBUG)
    else:
        log.setLevel(logging.INFO)

    return log


def main():
    opts = parse_opts()
    global LOG
    LOG = setup_logging(opts.debug, opts.timestamps)

    files = glob.glob(opts.glob)

    for filename in files:
        # skip directories
        if not os.path.isfile(filename):
            continue

        LOG.info('-'*60)
        unpacked = unpack(filename, opts.overwrite)

        if opts.cleanup:
            cleanup(unpacked)

    LOG.info('-'*60)

if __name__ == "__main__":
    main()
