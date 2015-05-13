# Get mysql up and running
class mysql {
    package { [ "mysql-server", "libmysqlclient-dev" ]:
        ensure => present,
        require => Exec["apt-get-update"];
    }
}