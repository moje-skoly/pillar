nginx:
  ng:
    # PPA install
    install_from_ppa: True
    # Set to 'stable', 'development' (mainline), 'community', or 'nightly' for each build accordingly ( https://launchpad.net/~nginx )
    ppa_version: 'stable'

    # Source compilation is not currently a part of nginx.ng
    from_source: False

    source:
      opts: {}

    package:
      opts: {} # this partially exposes parameters of pkg.installed

    service:
      enable: True # Whether or not the service will be enabled/running or dead
      opts: {} # this partially exposes parameters of service.running / service.dead

    server:
      opts: {} # this partially exposes file.managed parameters as they relate to the main nginx.conf file

      # nginx.conf (main server) declarations
      # dictionaries map to blocks {} and lists cause the same declaration to repeat with different values
      config: 
        worker_processes: 2
        pid: /run/nginx.pid
        events:
          worker_connections: 768
        http:
          sendfile: 'on'
          include:
            - /etc/nginx/mime.types
            - /etc/nginx/conf.d/*.conf
            - /etc/nginx/sites-enabled/*

    vhosts:
      disabled_postfix: .disabled # a postfix appended to files when doing non-symlink disabling
      symlink_opts: {} # partially exposes file.symlink params when symlinking enabled sites
      rename_opts: {} # partially exposes file.rename params when not symlinking disabled/enabled sites
      managed_opts: {} # partially exposes file.managed params for managed vhost files
      dir_opts: {} # partially exposes file.directory params for site available/enabled dirs

      # vhost declarations
      # vhosts will default to being placed in vhost_available
      managed:
        admin: # relative pathname of the vhost file
          enabled: True
          overwrite: True # overwrite an existing vhost file or not
          
          # May be a list of config options or None, if None, no vhost file will be managed/templated
          # Take server directives as lists of dictionaries. If the dictionary value is another list of
          # dictionaries a block {} will be started with the dictionary key name
          config:
            - server:
              - server_name: admin.mojeskoly.cz 
              - listen: 
                - 80
              - root: /var/www/admin
              - location /: 
                - rewrite: 
                  - ^([^.]*[^/])$ 
                  - $1/
                  - permanent
                - try_files:  
                  - $uri
                  - /index.php$is_args$args
              - location ~ \.php$: 
                - fastcgi_pass:    unix:/var/run/php7-admin.sock
                - fastcgi_index:   index.php
                - include:         fastcgi_params
                - fastcgi_param:  SCRIPT_FILENAME $document_root$fastcgi_script_name
                - fastcgi_param:  PATH_INFO $fastcgi_path_info
                - fastcgi_param:  PATH_TRANSLATED $document_root$fastcgi_path_info
        node: # relative pathname of the vhost file
          enabled: True
          overwrite: True # overwrite an existing vhost file or not
          
          # May be a list of config options or None, if None, no vhost file will be managed/templated
          # Take server directives as lists of dictionaries. If the dictionary value is another list of
          # dictionaries a block {} will be started with the dictionary key name
          config:
            - server:
              - server_name: 
                - mojeskoly.cz
                - www.mojeskoly.cz 
              - listen: 
                - 80
              - root: /var/www/frontend
              - location /:
                - proxy_pass: http://127.0.0.1:8000
