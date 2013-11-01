node 'development' {

	file { '/etc/apache2/sites-available/default':
		ensure 	=> file,
		source	=> '/vagrant/manifests/default_devel.vhost',
		require	=> Package['apache2'],
		notify	=> Service['apache2'],
	}	

}

node 'testing' {

	file { '/etc/apache2/sites-available/default':
		ensure 	=> file,
		source	=> '/vagrant/manifests/default_testing.vhost',
		require	=> Package['apache2'],
		notify	=> Service['apache2'],
	}	

}