## php.ng pillar examples

php:
  # Use ppa instead the default repository (only Debian family)
  use_ppa: True
  # Set the ppa name (valid only if use_ppa is not none)
  ppa_name: 'ondrej/php'
  ng:
    version: '7.0'
    fpm:

      # settings for the php-fpm service
      service:
        # if True, enables the php-fpm service, if False disables it
        enabled: True
        # additional arguments passed forward to
        # service.enabled/disabled
        opts:
          reload: True

      # settings for the relevant php-fpm configuration files
      config:

        # options to manage the php.ini file used by php-fpm
        ini:
          # arguments passed through to file.managed
          opts:
            recurse: True
          # php.ini file contents that will be merged with the
          # defaults in php.ng.ini.defaults. See php.ng.ini.defaults for
          # syntax guidelines.
          settings:
            PHP:
              engine: 'Off'
#              extension: [pdo_mysql.so, iconv.so, openssl.so]

        # options to manage the php-fpm conf file
        conf:
          # arguments passed through to file.managed
          opts:
            recurse: True
          # php-fpm conf file contents that will be merged with
          # php.ng.lookup.fpm.defaults. See php.ng.ini.defaults for
          # ini-style syntax guidelines.

      # settings for fpm-pools
      pools:
        # name of the pool file to be managed, this will be appended
        # to the path specified in php.ng.lookup.fpm.pools
        'www.conf':
          # If true, the pool file will be managed, if False it will be
          # absent
          enabled: True
          # arguments passed forward to file.managed or file.absent
          opts:
             replace: True 

          # pool file contents. See php.ng.ini.defaults for ini-style
          # syntax guidelines.
          settings:
            admin:
              user: www-data
              group: www-data
              listen: /var/run/php7-admin.sock
              listen.owner: www-data
              listen.group: www-data
              listen.mode: 0660
              pm: dynamic
              pm.max_children: 5
              pm.start_servers: 2
              pm.min_spare_servers: 1
              pm.max_spare_servers: 3
              'php_admin_value[memory_limit]': 64M 

    # php-cli settings
    cli:
      # settings to manage the cli's php.ini
      ini:
        # opts passed forward directly to file.managed
        opts:
          replace: False
        # contents of the php.ini file that are merged with defaults
        # from php.ng.ini.defaults. See php.ng.ini.defaults for ini-style
        # syntax guidelines
        settings:
          PHP:
            engine: 'Off'

