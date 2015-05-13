# Configure apache2
class apache2::config {
    apache2::loadmodule { "env": }
    apache2::loadmodule { "setenvif": }
    apache2::loadmodule { "headers": }
    apache2::loadmodule { "expires": }
    apache2::loadmodule { "alias": }
    apache2::loadmodule { "rewrite": }
    apache2::loadmodule { "proxy": }
    apache2::loadmodule { "proxy_http":
        require => Apache2::Loadmodule['proxy']
    }
    apache2::loadmodule { "vhost_alias": }
    file { "/etc/apache2/ssl":
        ensure => directory, mode => 0755;
    }
    file { "/etc/apache2/ssl/apache.crt":
        source => "puppet:///modules/apache2/ssl/apache.crt",
        require => File["/etc/apache2/ssl"],
    }
    file { "/etc/apache2/ssl/apache.key":
        source => "puppet:///modules/apache2/ssl/apache.key",
        require => File["/etc/apache2/ssl"],
    }
    apache2::loadmodule { "ssl":
        require => [
            File["/etc/apache2/ssl/apache.crt"],
            File["/etc/apache2/ssl/apache.key"],
        ]
    }
    file { "/etc/apache2/sites-enabled/000-default.conf":
        ensure => absent;
    }        
    file { "/etc/apache2/sites-enabled/mozilla-kuma-apache.conf":
        source => "puppet:///modules/apache2/mozilla-kuma-apache.conf",
        require => [
            Package['apache2'],
            Apache2::Loadmodule['env'],
            Apache2::Loadmodule['setenvif'],
            Apache2::Loadmodule['headers'],
            Apache2::Loadmodule['expires'],
            Apache2::Loadmodule['alias'],
            Apache2::Loadmodule['rewrite'],
            Apache2::Loadmodule['ssl'],
            Apache2::Loadmodule['proxy'],
            Apache2::Loadmodule['proxy_http'],
            Apache2::Loadmodule['vhost_alias'],
        ];
    }
    file { "/etc/apache2/conf-enabled/all-servers.conf":
        source => "puppet:///modules/apache2/all-servers.conf",
        require => [
            Package['apache2'],
            Apache2::Loadmodule['env'],
            Apache2::Loadmodule['setenvif'],
            Apache2::Loadmodule['headers'],
        ];
    }
    service { "apache2":
        ensure    => running,
        enable    => true,
        require   => [ Package['apache2'], ],
        subscribe => [
            File['/etc/apache2/sites-enabled/mozilla-kuma-apache.conf'],
            File['/etc/apache2/conf-enabled/all-servers.conf'],
        ]
    }
}
