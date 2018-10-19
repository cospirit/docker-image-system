#!/usr/bin/env python

import sys
import os
import signal

def write_stdout(s):
    # Only eventlistener protocol messages may be sent to stdout
    sys.stdout.write(s)
    sys.stdout.flush()

def write_stderr(s):
    sys.stderr.write(s)
    sys.stderr.flush()

def main():
    while 1:
        # Transition from ACKNOWLEDGED to READY
        write_stdout('READY\n')

        # Read header line
        line = sys.stdin.readline()

        # Read event payload
        headers = dict([ x.split(':') for x in line.split() ])
        data = sys.stdin.read(int(headers['len']))

        pidfile = open('/var/run/supervisord.pid','r')
        pid = int(pidfile.readline());
        os.kill(pid, signal.SIGQUIT)

        # Transition from READY to ACKNOWLEDGED
        write_stdout('RESULT 2\nOK')

if __name__ == '__main__':
    main()
