elasticsearch:
  config:
    cluster:
      name: naseskoly
    node:
      name: {{ grains['fqdn'] }}
      max_local_storage_nodes: 1
    path:
      conf: /etc/elasticsearch
      data: /var/data/elasticsearch
      logs: /var/log/elasticsearch
    bootstrap:
      mlockall: false
    discovery:
      zen:
        minimum_master_nodes: 1
        ping:
          multicast:
            enabled: false
          unicast:
            hosts: []
        fd:
          ping_timeout: 30s
          ping_retries: 10
    network:
      host: _global_
      bind_host:
        - _global_
        - _local_
    http:
      cors:
        enabled: true
        allow-origin: '*'
    index:
      number_of_shards: 1
  pid_dir: /var/run/elasticsearch
  plugins:
    installed:
      - name: analysis-icu
        path: analysis-icu
  cluster_node_ips:
    - 10.0.2.15
  client_ips:
     - 127.0.0.1 # dominik home

common:
  vm:
    swappiness: 0
