require 'spec_helper'
describe 'lamp::app' do
  let(:facts) do
    {
      ipaddress_ens160: '1.2.3.4',
      kernel: 'Linux',
      lsbdistcodename: 'xenial',
      lsbdistrelease: '16.04',
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

  it { should contain_class('lamp::app') }
  it { should compile }

  it { should contain_class('apache::mod::rewrite') }

  it do
    should contain_class('apache')
      .with(
        server_tokens: 'Prod',
        server_signature: 'Off',
        purge_vhost_dir: false
      )
  end

  it { should contain_class('apt') }

  it do
    should contain_class('mysql::client')
      .with(
        package_name: 'mariadb-client-10.1'
      )
  end

  it do
    should contain_class('php').with_extensions(
      'mbstring' => {},
      'gd' => {},
      'curl' => {},
      'json' => {},
      'mysql' => {
        'settings' => {
          'extension' => ''
        }
      }
    ).with_settings(
      'PHP/max_execution_time' => '90',
      'PHP/max_input_time' => '60',
      'PHP/memory_limit' => '256M',
      'PHP/post_max_size' => '32M',
      'PHP/upload_max_filesize' => '32M',
      'PHP/max_file_uploads' => '20',
      'PHP/display_errors' => 'Off',
      'PHP/error_reporting' => 'E_ALL & ~E_DEPRECATED & ~E_STRICT',
      'PHP/default_charset' => 'UTF-8',
      'Date/date.timezone' => 'Europe/London'
    )
  end

  it do
    should contain_class('php::globals')
      .with(
        php_version: '7.2',
        config_root: '/etc/php/7.2'
      )
  end

  it { should contain_class('wget') }

  it { should contain_apache__mod('proxy') }
  it { should contain_apache__mod('proxy_fcgi') }

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
    should contain_php__apache_vhost('default').with(
      fastcgi_socket:
        'fcgi://127.0.0.1:9000/var/www/lamp/www/$1',
      docroot: '/var/www/lamp'
    )
  end

  it do
    should contain_file('/etc/php/7.2/mods-available/mysql.ini')
      .with(
        ensure: 'present',
        replace: 'yes',
        content: '',
        mode: '0644'
      )
  end

  it do
    should contain_file('/var/www')
      .with(ensure: 'directory')
  end

  it do
    should contain_file('/var/www/lamp')
      .with(
        ensure: 'directory',
        owner: 'www-data',
        group: 'www-data',
        mode: '0755'
      )
  end
end
