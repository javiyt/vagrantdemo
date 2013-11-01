import 'nodes.pp'

Exec {
	path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}

exec { 'apt-update':
    command => '/usr/bin/apt-get update',
}

package { 
	['apache2', 'php5', 'libapache2-mod-php5']:
		ensure => installed,
}

service { 'apache2':
    enable => true,
	ensure => running,
	require	=> Package['apache2'],
}

Exec['apt-update'] -> Package <| |>