Exec {
	path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}

package { 
	'apache2':
		ensure => installed,
}

service { "apache2":
    enable => true,
	ensure => running,
	require	=> Package['apache2'],
}

file { '/etc/apache2/sites-available/default':
	ensure 	=> file,
	source	=> '/vagrant/manifests/default.vhost',
	require	=> Package['apache2'],
	notify	=> Service['apache2'],
}