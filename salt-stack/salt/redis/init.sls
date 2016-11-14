redis-server:
  pkg:
    - installed
  service:
    - running 
    - enable: True
    - watch:
      - pkg: redis-server
      - file: /etc/redis/redis.conf
