# volume_attach

## Purpose
* init script to attach single formatted EBS volume from pool of available volumes

## Supported OS
* working on CentOS 5/6
* should work on other SysV systems 

## Requirements
- ec2-api-tools

## Hiera Example
```
volume_attach::config_file_template: 'volume_attach/volume_attach.erb'
volume_attach::options_hash:
  type: standard
  size: 1024
  mountpoint: /storage
  ```
