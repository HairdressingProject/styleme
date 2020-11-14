# CPU and Memory monitor scripts

Bash scripts that retrieve CPU and memory usage metrics that are sent to Pushgateway. Both scripts should be placed on the remote machine that runs the PicturesAPI server.

```shell script
chmod u+x cpu-mon
chmod u+x memory-mon
```

Both scripts run just once, so a simple way to execute them every second we can use sleep command:

```shell script
while sleep 1; do ./cpu-mon; done;
```

```shell script
while sleep 1; do ./memory-mon; done;
```
