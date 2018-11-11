require 'spec_helper'

describe 'lamp::db' do
  let(:facts) do
    {
      kernel: 'Linux',
      lsbdistcodename: 'xenial',
      operatingsystem: 'Ubuntu',
      operatingsystemmajrelease: '16.04',
      operatingsystemrelease: '16.04',
      os: {
        name: 'Ubuntu',
        release: {
          full: '16.04'
        }
      },
      osfamily: 'Debian'
    }
  end

  it { should contain_class('lamp::db') }
  it { should compile }

  it { should contain_class('apt') }

  it do
    should contain_apt__source('mariadb').with(
      location: 'http://mirrors.coreix.net/mariadb/repo/10.1/ubuntu',
      release: facts[:lsbdistcodename],
      repos: 'main',
      key: {
        'id' => '0xF1656F24C74CD1D8',
        'server' => 'hkp://keyserver.ubuntu.com:80'
      },
      include: {
        'src' => false,
        'deb' => true
      }
    )
  end

  it do
    should contain_class('mysql::server')
      .with(
        package_name: 'mariadb-server-10.1',
        service_name: 'mysql'
      ).with_override_options(
        'mysqld' => {
          'log-error' => '/var/log/mysql/mariadb.log',
          'pid-file' => '/var/run/mysqld/mysqld.pid',
          'expire_logs_days' => '10',
          'key_buffer_size' => '16M',
          'max_allowed_packet' => '16M',
          'max_binlog_size' => '100M',
          'max_connections' => '151',
          'port' => '3306',
          'query_cache_limit' => '1M',
          'query_cache_size' => '16M',
          'thread_cache_size' => '8',
          'thread_stack' => '256K',
          'user' => 'mysql',
          'bind-address' => '0.0.0.0'
        },
        'mysqld_safe' => {
          'log-error' => '/var/log/mysql/mariadb.log'
        },
        'mysqldump' => {
          'max_allowed_packet' => '16M',
          'quick' => true,
          'quote-names' => true
        }
      )
  end

  it do
    should contain_class('mysql::client')
      .with(
        package_name: 'mariadb-client-10.1'
      )
  end
end
