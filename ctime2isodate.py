#!python3
import datetime
import re
import sys
import io
from signal import signal, SIGPIPE, SIG_DFL
signal(SIGPIPE,SIG_DFL) 

if __name__ == "__main__":
    if not sys.stdin.isatty():
        # stdin preferred
        fs = sys.stdin
    elif len(sys.argv) >= 2:
        # if stdin is not available, try last parameter as file name
        filename = sys.argv[len(sys.argv) - 1]
        try:
            fs = open(filename, 'r')
        except IOError:
            print >> sys.stderr, "File not found or occupied by other process: " + filename
            print_help()
            exit()
    else:
        print >> sys.stderr, "Can't find file to read from."
        print_help()
        exit()
    line = fs.readline()
    while line != "":
        match = re.search("^\w+ \w+ \d+ \d+:\d+:\d+\.\d+", line)
        if match != None:
            ctime = match.group(0)
            # use current year to fill the blank
            uat = datetime.datetime.strptime(ctime + " " + str(datetime.datetime.now().year), "%a %b %d %H:%M:%S.%f %Y")
            at = uat.astimezone()
            isotime = at.isoformat()
            line = line.replace(ctime, isotime)
            sys.stdout.write(line)
        line = fs.readline()

    sys.stdout.flush()