# mysql config
class mysql::config {
    # Ensure MySQL answers on 127.0.0.1, and not just unix socket
    file {
        "/etc/mysql/my.cnf":
            source => "puppet:///modules/mysql/my.cnf",
            owner => "root", group => "root", mode => 0644;
        "/tmp/init.sql":
            ensure => file,
            source => "puppet:///modules/mysql/init.sql",
            owner => "vagrant", group => "vagrant", mode => 0644;
    }
    service { "mysql":
        ensure => running,
        enable => true,
        require => [ Package['mysql-server'], File["/etc/mysql/my.cnf"] ],
        subscribe => [ File["/etc/mysql/my.cnf"] ]
    }
    exec {
        "setup_mysql_databases_and_users":
            command => "/usr/bin/mysql -u root < /tmp/init.sql",
            unless => "/usr/bin/mysql -uroot -B -e 'show databases' 2>&1 | grep -q 'kuma'",
            require => [
                File["/tmp/init.sql"],
                Service["mysql"]
            ];
    }

}
