define nagios::hostgroup() {
  include ::nagios::params

  $alias = inline_template('<%= name.capitalize -%>')

  nagios_hostgroup { $name:
    ensure => present,
    alias  => $alias,
    target => "${nagios::params::conf_dir}/hostgroups.cfg",
  }
}
