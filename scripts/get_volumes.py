#!/usr/bin/python

# list all volumes for instances 
# usage: ./get_volumes.py {running|stopped}

import boto
import sys

ec2 = boto.connect_ec2()
reservations = ec2.get_all_instances(filters={'instance-state-name': sys.argv })
volumes = []
for r in reservations:
    for i in r.instances:
        volumes.extend(ec2.get_all_volumes(filters={'attachment.instance-id': i.id}))
print volumes
