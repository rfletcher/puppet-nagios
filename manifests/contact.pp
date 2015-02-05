define nagios::contact(
  $ensure = present,
  $alias  = undef,
  $email  = undef,
) {
  @@nagios_contact { $name:
    ensure => $ensure,
    alias  => $alias,
    email  => $email,
  }
}
