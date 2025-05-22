# expire-logs.sh

This script is used to remove expred log files.

## Usage

```txt
Usage: expire-logs.sh <log_folder> [days] [file_pattern]
  <log_folder>: Folder that stores the log.
  [days]: How many days you want to keep the logs. Defaults to +365
  [file_pattern]: File pattern name. Defaults to '*.gz'
```

## Examples

```bash
# find log files in /logs folder, remove those older than 365 days.
./expire-logs.sh /logs

# find log files in /logs folder, remove those older than 90 days.
./expire-logs.sh /logs +90 

# find log files in /logs folder whose filename meets pattern *.tar.gz, remove those older than 365 days.
./expire-logs.sh /logs +90 '*.tar.gz'
```