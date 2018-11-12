# Installs an app node
class lamp::app {

  include apt
  include wget
  include apache::mod::rewrite

  class { 'apache':
    server_tokens    => 'Prod',
    server_signature => 'Off',
    purge_vhost_dir  => false,
  }
  # MySQL Dependencies
  Apt::Source['mariadb']
  ~> Class['apt::update']
  ~> Class['mysql::client']

  apt::source { 'mariadb':
    location => 'http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu',
    release  => $::lsbdistcodename,
    repos    => 'main',
    key      => {
      id     => '0xF1656F24C74CD1D8',
      server => 'hkp://keyserver.ubuntu.com:80',
    },
    include  => {
      src => false,
      deb => true,
    },
  }

  file { '/var/www':
      ensure => 'directory',
  }
  ->file { '/var/www/lamp':
    ensure => 'directory',
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  apache::mod {
    'proxy': ;
    'proxy_fcgi': ;
  }

  class { 'php::globals':
    php_version => '7.2',
    config_root => '/etc/php/7.2',
  }
  ->class { 'php':
    ensure       => latest,
    manage_repos => true,
    fpm          => true,
    dev          => false,
    composer     => false,
    pear         => true,
    phpunit      => false,
    extensions   => {
      mbstring => {},
      gd       => {},
      curl     => {},
      json     => {},
      mysql    => {
        settings => {
          'extension' => '',
        },
      },
    },
    settings     => {
      'PHP/max_execution_time'  => '90',
      'PHP/max_input_time'      => '60',
      'PHP/memory_limit'        => '256M',
      'PHP/post_max_size'       => '32M',
      'PHP/upload_max_filesize' => '32M',
      'PHP/max_file_uploads'    => '20',
      'PHP/display_errors'      => 'Off',
      'PHP/error_reporting'     => 'E_ALL & ~E_DEPRECATED & ~E_STRICT',
      'PHP/default_charset'     => 'UTF-8',
      'Date/date.timezone'      => 'Europe/London',
    },
  }
  ->file { '/etc/php/7.2/mods-available/mysql.ini':
    ensure  => 'present',
    replace => 'yes',
    content => '',
    mode    => '0644',
  }
  ->php::apache_vhost { 'default':
    vhost          => $::fqdn,
    fastcgi_socket => 'fcgi://127.0.0.1:9000/var/www/lamp/www/$1',
    docroot        => '/var/www/lamp',
  }

  class { 'mysql::client':
    package_name   => 'mariadb-client-10.1',
  }

}
