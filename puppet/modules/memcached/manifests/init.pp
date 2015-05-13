# Get memcached up and running
class memcached {
    package { [ "memcached", "libmemcached-dev" ]:
        ensure => present,
        require => Exec["apt-get-update"];
    }
    service { "memcached":
        ensure => running,
        enable => true,
        require => [ Package["memcached"] ]
    }
}