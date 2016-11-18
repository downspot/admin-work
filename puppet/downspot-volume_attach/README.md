# volume_attach

## Purpose
* init script to attach single formatted EBS volumes from pool of available volumes
* multipe scripts can be added to support more than one volume if needed
* extra script added for percona db back purposes 

## Supported OS
* working on CentOS 5/6
* should work on other SysV systems 

## Requirements
- ec2-api-tools

## Hiera Example
```
classes:
  - volume_attach
  - volume_attach::backup


volume_attach::config_file_template: 'volume_attach/volume_attach.erb'
volume_attach::options_hash:
  device: /dev/xvdk
  type: standard
  size: 150
  mountpoint: /var/lib/mysql

volume_attach::backup::config_file_template: 'volume_attach/volume_attach_backup.erb'
volume_attach::backup::options_hash:
  device: /dev/xvdl
  type: standard
  size: 300
  mountpoint: /xtrabackup
  ```
