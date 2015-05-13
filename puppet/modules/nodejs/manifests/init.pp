# Get node.js and npm installed Ubuntu 12.04 LTS
class nodejs {
    package { "nodejs":
        ensure => present;
    }
    package { "npm":
        ensure => present;
    }    
    file { "/usr/local/bin/node":
        target => "/usr/bin/nodejs",
        ensure => link,
        require => Package['nodejs']
    }
    file { "/usr/local/lib/node_modules/fibers":
        ensure => absent,
        force => true
    }
    file { "/home/vagrant/src/kumascript/node_modules/fibers":
        ensure => absent,
        force => true
    }
    exec { 'npm-fibers-install':
        command => "/usr/bin/npm install -g fibers@1.0.1",
        creates => "/usr/lib/node_modules/fibers",
        require => [
            Package["nodejs"],
            Package["npm"],
            File["/usr/local/bin/node"],
            File["/usr/local/lib/node_modules/fibers"],
            File["/home/vagrant/src/kumascript/node_modules/fibers"]
        ]
    }
}
