python-mysqldb:
  pkg.installed

sst-user:
  require:
    - pkg: python-mysqldb
  mysql_user.present:
    - name: sstuser
    - host: localhost
    - password: {{pillar.get('db_users', {})['sstuser']}}

backup-user:
  require:
    - pkg: python-mysqldb
  mysql_user.present:
    - name: backup
    - host: '%'
    - password: {{pillar.get('db_backup_pass')}}

sst-grants:
  require:
    - pkg: python-mysqldb
  mysql_grants.present:
    - grant: 'RELOAD,LOCK TABLES,REPLICATION CLIENT'
    - host: localhost
    - database: '*.*'
    - user: sstuser
    - require:
      - mysql_user.present: sst-user

backup-grants:
  require:
    - pkg: python-mysqldb
  mysql_grants.present:
    - grant: 'RELOAD,SELECT,SUPER,EVENT,REPLICATION CLIENT'
    - host: '%'
    - database: '*.*'
    - user: backup
    - require:
      - mysql_user.present: backup-user
