# Community MongoDB Log Rotate
## Reconfig MongoDB
Edit the `logRotate` setting or add it to config file:
```yaml
systemLog:
  logRotate: reopen
  ...
```

## Config logrotated

Create file `/etc/logrotate.d/mongod`:
```
/var/log/mongodb/mongod.log {
   daily
   rotate 180
   dateext
   compress
   missingok
   notifempty
   sharedscripts
   create 640 mongod mongod 
   postrotate
      /bin/kill -SIGUSR1 `cat /var/run/mongodb/mongod.pid 2> /dev/null` 2> /dev/null || true
   endscript
}
```
The PID file `/var/run/mongodb/mongod.pid` path can be found in your MongoDB config file by the name `pidFilePath`.

## Test Log Rotate
With the following command, log should be rotated.
```bash
logrotate --force /etc/logrotate.d/mongod
```