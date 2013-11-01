node 'web' {

	package { 
		['apache2', 'php5', 'libapache2-mod-php5', 'php5-mysql']:
			ensure => installed,
	}

	service { 'apache2':
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

}

node 'database' {

	package { 'mysql-server':
		ensure => installed,
	}

	service { 'mysql':
	    enable => true,
		ensure => running,
		require => Package['mysql-server'],
	}

	file { '/etc/mysql/my.cnf':
		ensure 	=> file,
		source	=> '/vagrant/manifests/my.cnf',
		require	=> Package['mysql-server'],
		notify	=> Service['mysql'],
	}

	exec { 'uncompress_database':
		command => 'gunzip -d -c /vagrant/manifests/world.sql.gz > world.sql',
		cwd		=> '/tmp',
	}

	exec { 'load_database':
		command => 'mysql -u root test < world.sql',
		cwd		=> '/tmp',
		require	=> [Package['mysql-server'],Exec['uncompress_database']],
	}

	exec { 'create_vagrant_user':
		command => 'mysql -e "CREATE USER \'vagrant\'@\'192.168.50.1\' IDENTIFIED BY  \'vagrant\'; GRANT ALL PRIVILEGES ON *.* TO  \'vagrant\'@\'192.168.50.1\' IDENTIFIED BY \'vagrant\' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;"',
		require	=> Package['mysql-server'],
	}
}