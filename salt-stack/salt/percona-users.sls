python-mysqldb:
  pkg.installed

flusher-user:
  require:
    - pkg: python-mysqldb
  mysql_user.present:
    - name: flusher
    - host: localhost
    - password: {{ salt['pillar.get']('db_users:flusher_user_pass') }}

flusher-grants:
  require:
    - pkg: python-mysqldb
  mysql_grants.present:
    - grant: 'RELOAD,SUPER'
    - host: localhost
    - database: '*.*'
    - user: flusher
    - require:
      - mysql_user: flusher-user

sstuser-user:
  require:
    - pkg: python-mysqldb
  mysql_user.present:
    - name: sstuser
    - host: localhost
    - password: {{ salt['pillar.get']('db_users:flusher_user_pass') }}

sstuser-grants:
  require:
    - pkg: python-mysqldb
  mysql_grants.present:
    - grant: 'PROCESS,RELOAD,LOCK TABLES,REPLICATION CLIENT'
    - host: localhost
    - database: '*.*'
    - user: sstuser
    - require:
      - mysql_user: sstuser-user
