include:
  - redis

redis-sentinel:
  service:
    - running 
    - enable: True
    - sig: redis-sentinel
    - require:
      - pkg: redis-server
      - file: /etc/init.d/redis-sentinel
    - watch:
      - file: /etc/init.d/redis-sentinel
      - file: /etc/redis/sentinel.conf

/etc/init.d/redis-sentinel:
  file:
    - managed
    - source: salt://redis/redis-sentinel-init
    - mode: 755
    - user: root
    - group: root
    - require:
      - pkg: redis-server

/etc/redis/sentinel.conf:
  file:
    - managed
    - source: salt://redis/sentinel.conf
    - mode: 644
    - user: redis
    - group: redis
    - require:
      - pkg: redis-server
