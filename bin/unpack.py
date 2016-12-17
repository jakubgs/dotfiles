#!/usr/bin/env python2.7
import os
import re
import sys
import glob
import shutil
import argparse

try:
    import sh
except ImportError as ex:
    print 'Missing required Python 2.7 module: sh'
    print 'URL: https://pypi.python.org/pypi/sh'
    print 'To install run:'
    print 'sudo pip2 install sh'
    sys.exit(1)

HELP_MESSAGE='''
This script is intended for mass unpacking of directories.
'''.strip()

cmds = {
    r'.*\.(tar\.gz|tgz)':       lambda f,d: sh.tar.bake('xvzf')(f, C=d),
    r'.*\.(tar.bz2|tbz2|tbz)':  lambda f,d: sh.tar.bake('xvjf')(f, C=d),
    r'.*\.(zip)':               lambda f,d: sh.unzip.bake()(o=f, d=d),
    r'.*\.(rar)':               lambda f,d: sh.unrar.bake('x -o- -ad')(f),
    r'.*\.(7z)':                lambda f,d: sh('7z').bake('x -y')(f, o=d),
    r'.*\.(zsh)':               lambda f,d: sh.lha.bake('e')(f, w=d),
}

def unpack(filename, overwrite=False):
    for regex, cmd in cmds.iteritems():
        basename, ext = os.path.splitext(filename)

        matches = re.findall(regex, filename)

        if len(matches) == 0:
            continue

        if os.path.isdir(basename) and not overwrite:
            print 'SKIP - Exists:', basename
            return None

        print 'Unpacking: {} -> {}'.format(filename, basename)
        rval = cmd(filename, basename)
        print rval
        return basename
    
    print 'SKIP - Unknown file extension:', ext
    return None


def cleanup(unpacked):
    print 'Cleanup:', unpacked
    contents = gob.glob('{}/*'.format(unpacked))

    if len(contents) == 1:
        print ' * Removing useless dir:', contents[0]
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
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Enable verbose messages')
    return parser.parse_args()


def main():
    opts = parse_opts()

    files = glob.glob(opts.glob)

    for filename in files:
        # skip directories
        if not os.path.isfile(filename):
            continue

        print '-'*100
        unpacked = unpack(filename, opts.overwrite)

        if opts.cleanup:
            cleanup(unpacked)

    print '-'*100

if __name__ == "__main__":
    main()
