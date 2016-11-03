#!/usr/bin/python

# modified from https://gist.github.com/kjoconnor/7344485
# user input for how many days to keep
# usage: ./delete_snapshots.py 30

import sys
import boto

from datetime import datetime, timedelta

try:
	days = int(sys.argv[1])
except IndexError:
	days = 30

delete_time = datetime.utcnow() - timedelta(days=days)


print 'Deleting any snapshots older than {days} days'.format(days=days)


ec2 = boto.connect_ec2()


snapshots = ec2.get_all_snapshots(owner='self')


deletion_counter = 0
size_counter = 0

for snapshot in snapshots:
	start_time = datetime.strptime(
		snapshot.start_time,
		'%Y-%m-%dT%H:%M:%S.000Z'
	)

	if start_time < delete_time:
		print 'Deleting {id}'.format(id=snapshot.id)
		deletion_counter = deletion_counter + 1
		size_counter = size_counter + snapshot.volume_size
		# Just to make sure you're reading!
		snapshot.delete(dry_run=False)

print 'Deleted {number} snapshots totalling {size} GB'.format(
	number=deletion_counter,
	size=size_counter
)
