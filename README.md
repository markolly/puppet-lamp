# Puppet Module: puppet-lamp
Puppet module to manage configuration of LAMP Server.

## Dependencies
- puppetlabs-stdlib
- maestrodev-wget
- puppetlabs/mysql
- puppet/php
- puppetlabs/apache

## Vagrant
A Vagrant box for testing the configuration is available at:
https://github.com/markolly/vagrant-lamp

## Installation
```
git clone git@github.com:markolly/puppet-lamp.git
cd puppet-lamp
bundle
ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

To bypass pre-commit git hook tests run commits with the --no-verify option or -n flag. This is particularly useful when making changes to tests.
```
git commit -nm "Commit message"
```
