include:
  - redis

/etc/redis/redis.conf:
  file:
    - managed
    - source: salt://redis/redis.conf-master
    - mode: 644
    - user: redis
    - group: redis
    - require:
      - pkg: redis-server
