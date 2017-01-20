#!/bin/sh

# percona full hot backup
#
# restore procedure 
#
# decompression
# innobackupex --parallel=4 --decompress /xtrabackup/backupdir
#
# delete compressed files
# find /xtrabackup/backupdir -iname "*\.qp" -exec rm -v {} \;
#
# prepare 
# innobackupex --use-memory=1G --apply-log /xtrabackup/backupdir
#
# restore into data dir
# innobackupex --copy-back /xtrabackup/backupdir
#
# change owner 
# chown -R mysql:mysql /var/lib/mysql

user="user"
pass="pass"
backupdir="/xtrabackup"
date="`date "+%F"`"
bucket="backups.example.com/database/xtrabackup/`hostname -s`"
dumplog="/var/log/xtrabackup.log-"$date""
md5remote="/tmp/md5remote_out.txt"
md5local="/tmp/md5local_out.txt"
diffout="/tmp/diffout.txt"


# create backup directory
if [ ! -d $backupdir ] ; then 
  mkdir -p $backupdir
fi


# run the backup
echo ""
echo -e "Running xtrabackup on `hostname`... \c"
innobackupex --user=$user --password=$pass --no-timestamp --slave-info --safe-slave-backup --backup --compress --compress-threads=5 $backupdir/$date > $dumplog 2>&1
echo "Done."
echo ""
echo "Backup log can be found at `hostname`:"$dumplog""
echo ""


# check end of log for dump completion
tail -1 $dumplog | grep "completed OK\!" > /dev/null

echo -e "Checking for proper backup exit status... \c"

if [ $? == "1" ]; then
  echo "Backup has failed."
  exit 1 
else
  echo "Backup has completed successfully."
fi
echo ""


# upload to s3
echo -e "Copying $backupdir/$date to s3://$bucket/... \c"
s3cmd sync --quiet $backupdir/$date s3://$bucket/ > /dev/null 2>&1
echo "Done."
echo ""


# check local and remote md5sum
echo -e "Cheecking local and S3 md5sum... \c"
s3cmd ls --list-md5 --recursive s3://$bucket/$date/ | awk {'print $4" "$5'} | sed 's= .*/= =' | sort -k 2 > $md5remote
find $backupdir/$date -type f | xargs md5sum | sed 's= .*/= =' | sort -k 2 > $md5local

diff $md5local $md5remote > $diffout

if [ -s $diffout ]; then
 echo ""
 echo "Upload to s3 has failed, check output for errors."
 echo ""
 cat $diffout
 exit 1
else
 echo "Successfull md5sum check."
 echo ""
fi


# delete local
echo "Removing local backups over 14 days old."
find $backupdir -maxdepth 1 -type d -not -name xtrabackup -mtime +14 -exec rm -fr -v {} \;
echo ""
echo "Removing local logs over 14 days old."
find /var/log -type f -name "xtrabackup*" -mtime +14 -exec rm -fr -v {} \;
