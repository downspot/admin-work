logrotate:
  pkg.installed

/etc/logrotate.d/mysql-slowlog:
  file.managed:
    - source: salt://percona-logrotate/mysql-slowlog
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/logrotate.d/mysql-general:
  file.managed:
    - source: salt://percona-logrotate/mysql-general
    - template: jinja
    - mode: 644
    - user: root
    - group: root

/etc/logrotate.d/mysql-error:
  file.managed:
    - source: salt://percona-logrotate/mysql-error
    - template: jinja
    - mode: 644
    - user: root
    - group: root
