redis-server:
  pkgrepo:
    - managed
    - ppa: chris-lea/redis-server
    - require in:
      - pkg: redis-server
  pkg:
    - latest
