# Installs an db node
class lamp::db {

  include apt

  # Dependencies
  Apt::Source['mariadb']
  ~> Class['apt::update']
  ~> Class['mysql::server']
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

  class { 'mysql::server':
    package_name     => 'mariadb-server-10.1',
    service_name     => 'mysql',
    override_options => {
      mysqld      => {
        'log-error'          => '/var/log/mysql/mariadb.log',
        'pid-file'           => '/var/run/mysqld/mysqld.pid',
        'expire_logs_days'   => '10',
        'key_buffer_size'    => '16M',
        'max_allowed_packet' => '16M',
        'max_binlog_size'    => '100M',
        'max_connections'    => '151',
        'port'               => '3306',
        'query_cache_limit'  => '1M',
        'query_cache_size'   => '16M',
        'thread_cache_size'  => '8',
        'thread_stack'       => '256K',
        'user'               => 'mysql',
        'bind-address'       => '0.0.0.0',
      },
      mysqld_safe => {
        'log-error'           => '/var/log/mysql/mariadb.log',
      },
      mysqldump   => {
        'max_allowed_packet' => '16M',
        'quick'              => true,
        'quote-names'        => true,
      },
    }
  }

  class { 'mysql::client':
    package_name   => 'mariadb-client-10.1',
  }

}
