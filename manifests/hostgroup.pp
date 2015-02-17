define nagios::hostgroup(
  $ensure = present,
  $alias  = undef,
) {
  @@nagios_hostgroup { $name:
    ensure => $ensure,
    alias  => $alias,
    target => "${nagios::params::hostgroup_conf_dir}/${name}.cfg",
  }
}
