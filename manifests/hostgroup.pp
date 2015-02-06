define nagios::hostgroup(
  $ensure = present,
  $alias  = undef,
) {
  @@nagios_hostgroup { $name:
    ensure => $ensure,
    alias  => $alias,
  }
}
