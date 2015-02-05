class nagios::users(
  $users,
) {
  $user_list = join( sort( keys( $users ) ), ',' )

  file_line { 'cgi.cfg: set authorized_for_all_host_commands':
    line  => "authorized_for_all_host_commands=${user_list}",
    match => "^authorized_for_all_host_commands=",
  }
  file_line { 'cgi.cfg: set authorized_for_all_hosts':
    line  => "authorized_for_all_hosts=${user_list}",
    match => "^authorized_for_all_hosts=",
  }
  file_line { 'cgi.cfg: set authorized_for_all_service_commands':
    line  => "authorized_for_all_service_commands=${user_list}",
    match => "^authorized_for_all_service_commands=",
  }
  file_line { 'cgi.cfg: set authorized_for_all_services':
    line  => "authorized_for_all_services=${user_list}",
    match => "^authorized_for_all_services=",
  }
  file_line { 'cgi.cfg: set authorized_for_configuration_information':
    line  => "authorized_for_configuration_information=${user_list}",
    match => "^authorized_for_configuration_information=",
  }
  file_line { 'cgi.cfg: set authorized_for_system_commands':
    line  => "authorized_for_system_commands=${user_list}",
    match => "^authorized_for_system_commands=",
  }
  file_line { 'cgi.cfg: set authorized_for_system_information':
    line  => "authorized_for_system_information=${user_list}",
    match => "^authorized_for_system_information=",
  }

  Htpasswd {
    target  => '/etc/nagios3/htpasswd.users',
    notify  => Service['nagios3'],
  }

  create_resources( 'htpasswd', hash_rename_keys( $users, {
    'password_hash' => 'cryptpasswd',
  }, 1 ) )

  file { '/etc/nagios3/htpasswd.users':
    mode => '0644',
  }
}
