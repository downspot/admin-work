include:
  - redis

/etc/redis/redis.conf:
  file:
    - managed
    - source: salt://redis/redis.conf-slave
    - template: jinja
    - mode: 644
    - user: redis
    - group: redis
    - require:
      - pkg: redis-server
