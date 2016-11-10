#!/bin/sh 

#
# requiremnts are python27 and pip for 2.7
#
# https://github.com/skymill/automated-ebs-snapshots
#
#
# generating configs for auto-ebs-snapshots
#
# start/stop daemon 
#
# /opt/rh/python27/root/usr/bin/automated-ebs-snapshots --config /etc/aws/auto-ebs-snapshots.conf --log-file /var/log/automated-ebs-snapshots.log --daemon start
# /opt/rh/python27/root/usr/bin/automated-ebs-snapshots --config /etc/aws/auto-ebs-snapshots.conf --log-file /var/log/automated-ebs-snapshots.log --daemon stop
#
# /root/scripts/get_volumes.py running
# /root/scripts/get_volumes.py stopped
#


# source ec2 info
. /etc/profile.d/ec2.sh

# source python27
. /opt/rh/python27/enable


# volumes attched to running instances
/root/scripts/get_volumes.py running | tr -d "[]" | sed 's/Volume:/\'$'\n/g ; s/, //g' | sed '1d' | sed 's/$/,daily,7/' > /etc/aws/auto-ebs-snapshots-volumes-active.conf

# add volues to watch list
/opt/rh/python27/root/usr/bin/automated-ebs-snapshots --config /etc/aws/auto-ebs-snapshots.conf --watch-file /etc/aws/auto-ebs-snapshots-volumes-active.conf

# volumes attched to stopped instances
/root/scripts/get_volumes.py stopped | tr -d "[]" | sed 's/Volume:/\'$'\n/g ; s/, //g' | sed '1d' | sed 's/$/,daily,7/' > /etc/aws/auto-ebs-snapshots-volumes-stopped.conf

# remove volumes from watch list
/opt/rh/python27/root/usr/bin/automated-ebs-snapshots --config /etc/aws/auto-ebs-snapshots.conf --unwatch-file /etc/aws/auto-ebs-snapshots-volumes-stopped.conf

# run to create/delete
/opt/rh/python27/root/usr/bin/automated-ebs-snapshots --config /etc/aws/auto-ebs-snapshots.conf --log-file /var/log/automated-ebs-snapshots.log --run
