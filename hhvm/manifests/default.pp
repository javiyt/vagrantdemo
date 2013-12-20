Exec {
    path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ]
}

file { 'apt_conf_unauthenticated':
    path => '/etc/apt/apt.conf.d/99-unauthenticated',
    ensure => file,
    content => 'APT::Get::AllowUnauthenticated "true";',
}

file { '/etc/nginx/sites-available/default':
    source => '/vagrant/manifests/default.vhost.conf',
    notify => Service['nginx'],
    require => [Package['nginx'], Exec['hhvm_server_run']],
}

exec { 'apt_update':
    command => '/usr/bin/apt-get update',
    require => File['apt_conf_unauthenticated'],
}

exec { 'hhvm_sources':
    command => 'echo deb http://dl.hhvm.com/ubuntu saucy main | sudo tee /etc/apt/sources.list.d/hhvm.list',
    notify => Exec['apt_update'],
}

exec { 'hhvm_server_run':
    command => 'hhvm --mode daemon -vServer.Type=fastcgi -vServer.Port=9000',
    cwd => '/vagrant',
    require => Package['hhvm-fastcgi'],
}

package { 'nginx':
    ensure => installed,
    require => Exec['apt_update'],
}

package { 'hhvm-fastcgi':
    ensure => installed,
    require => Exec['hhvm_sources'],
}

service { 'nginx':
    enable => true,
    ensure => running,
    require => Package['nginx'],
}

