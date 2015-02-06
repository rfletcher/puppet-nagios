define nagios::servicegroup() {
  include ::nagios::params

  $alias = inline_template('<%= name.capitalize -%>')

  nagios_servicegroup { $name:
    ensure => present,
    alias  => $alias,
    target => "${nagios::params::conf_dir}/servicegroups.cfg",
  }
}
