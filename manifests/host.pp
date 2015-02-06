define nagios::host(
  $ensure  = present,
  $address = undef,
  $groups  = undef,
) {
  include ::nagios::params

  $real_groups = is_array( $groups ) ? {
    true  => join( $groups, ',' ),
    false => $groups,
  }

  @@nagios_host { $name:
    ensure     => $ensure,
    address    => $address,
    hostgroups => $real_groups,
    target     => "${nagios::params::host_conf_dir}/${::clientcert}.cfg",
  }
}
