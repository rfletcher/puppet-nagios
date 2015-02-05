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

  class { '::nagios::users': users => $users, }

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

  # purge unmanaged nagios resources
  resources { 'nagios_command':      purge => true, }
  resources { 'nagios_contact':      purge => true, }
  resources { 'nagios_contactgroup': purge => true, }
  resources { 'nagios_host':         purge => true, }
  resources { 'nagios_hostgroup':    purge => true, }
  resources { 'nagios_hostextinfo':  purge => true, }
  resources { 'nagios_service':      purge => true, }
  resources { 'nagios_servicegroup': purge => true, }

  # # realize virtual nagios resources
  # Nagios_command <||>      { require => Package['nagios3'] }
  # Nagios_contact <||>      { require => Package['nagios3'] }
  # Nagios_contactgroup <||> { require => Package['nagios3'] }
  # Nagios_host <||>         { require => Package['nagios3'] }
  # Nagios_hostgroup <||>    { require => Package['nagios3'] }
  # Nagios_hostextinfo <||>  { require => Package['nagios3'] }
  # Nagios_service <||>      { require => Package['nagios3'] }
  # Nagios_servicegroup <||> { require => Package['nagios3'] }
}
