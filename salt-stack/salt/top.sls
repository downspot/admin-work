base:
  'db*':
    - percona-logrotate
  'db01':
    - percona-users
  'minion*':
    - redis
    - redis.sentinel-service
  'minion01.home.saldino.net':
    - redis.redis-master
  'minion02.home.saldino.net':
    - redis.redis-slave
  'minion03.home.saldino.net':
    - redis.redis-slave
