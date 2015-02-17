Facter.add( :configured_nagios_hostgroups ) do
  setcode do
    dir = "/etc/nagios3/conf.d/hostgroups"

    Dir.glob( "#{dir}/*.cfg" ).map { |p|
      File.basename( p, ".cfg" )
    }.join( ',' )
  end
end
