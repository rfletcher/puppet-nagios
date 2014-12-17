define nagios::nrpe::plugin(
  $ensure  = present,
  $content = undef,
  $source  = undef,
) {
  include ::nagios::nrpe

  file { "/usr/lib/nagios/plugins/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    group   => 'root',
    mode    => '0755',
    owner   => 'root',
    notify  => Service['nagios-nrpe-server'],
  }
}
