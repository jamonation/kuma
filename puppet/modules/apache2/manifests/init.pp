# Get apache up and running
class apache2 {
    package { "libapache2-mod-wsgi":
        ensure => purged;
    }
    package { [ "apache2" ]:
        ensure => present,
        require => Exec["apt-get-update"];
    }
}

define apache2::loadmodule () {
     exec { "/usr/sbin/a2enmod $name" :
          unless => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
          notify => Service[apache2]
     }
}
