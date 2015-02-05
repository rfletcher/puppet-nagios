define nagios::host(
  $ensure  = present,
  $address = undef,
  $groups  = undef,
) {
  $real_groups = is_array( $groups ) ? {
    true  => join( $groups, ',' ),
    false => $groups,
  }

  @@nagios_host { $name:
    ensure     => $ensure,
    address    => $address,
    hostgroups => $real_groups,
  }
}
