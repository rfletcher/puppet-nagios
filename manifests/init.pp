class nagios(
  $users = undef,
) {
  include ::nagios::server::commands
  include ::nagios::server::contacts
  include ::nagios::server::contactgroups
  include ::nagios::server::hosts
  include ::nagios::server::timeperiods
  include ::nagios::server::services

  ## install

  package { [
    'nagios3',
    'nagios-nrpe-plugin'
  ]:
    ensure => present,
    before => Service['nagios3'],
  }

  ## configure

  Augeas {
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }

  augeas { 'nagios.cfg: change defaults':
    context => '/files/etc/nagios3/nagios.cfg',
    changes => [
      'set check_external_commands 1',
      'set command_check_interval 15s',
      'set max_concurrent_checks 20',
      'set service_check_timeout 600',
    ],
  }

  File_line {
    path    => '/etc/nagios3/cgi.cfg',
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }

  # Augeas' Nagios lens can't parse this file. Use other means.
  file_line { 'cgi.cfg: set result_limit':
    line  => 'result_limit=0',
    match => '^result_limit=',
  }

  file_line { 'cgi.cfg: set use_large_installation_tweaks':
    line  => 'use_large_installation_tweaks=1',
    match => '^use_large_installation_tweaks=',
  }

  class { '::nagios::users':
    users   => $users,
    require => Package['nagios3'],
  }

  ## run

  service { 'nagios3':
    ensure     => running,
    enable     => true,
    hasrestart => true,
  }

  # include ::nagios::service

  # exec { 'external-commands':
  #   command => 'dpkg-statoverride --update --add nagios nagios 751 /var/lib/nagios3 && dpkg-statoverride --update --add nagios www-data 2710 /var/lib/nagios3/rw',
  #   unless  => 'dpkg-statoverride --list nagios nagios 751 /var/lib/nagios3 && dpkg-statoverride --list nagios www-data 2710 /var/lib/nagios3/rw',
  #   notify  => Service['nagios3'],
  # }

  # # Bug: 3299
  # exec { 'nagios: fix-permissions':
  #   command     => 'chmod -R go+r /etc/nagios3/conf.d',
  #   refreshonly => true,
  #   notify      => Service['nagios3'],
  # }

  # remove some default configuration

  file { [
    '/etc/nagios3/conf.d/contacts_nagios2.cfg',
    '/etc/nagios3/conf.d/extinfo_nagios2.cfg',
    '/etc/nagios3/conf.d/generic-host_nagios2.cfg',
    '/etc/nagios3/conf.d/generic-service_nagios2.cfg',
    '/etc/nagios3/conf.d/hostgroups_nagios2.cfg',
    '/etc/nagios3/conf.d/localhost_nagios2.cfg',
    '/etc/nagios3/conf.d/services_nagios2.cfg',
    '/etc/nagios3/conf.d/timeperiods_nagios2.cfg'
  ]:
    ensure => absent,
    notify => Service['nagios3'],
  }
}
