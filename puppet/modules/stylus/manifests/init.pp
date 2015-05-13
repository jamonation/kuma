# Get stylus
class stylus {
    exec { 'stylus-install':
        command => '/usr/bin/npm install -gf stylus@0.49.2',
        creates => '/usr/bin/stylus',
        require => [
            File['/usr/local/bin/node'],
        ]
    }
    file { '/usr/local/bin/stylus':
        ensure => link,
        target=> "/usr/bin/stylus",
        require => Exec['stylus-install'],
    }
}
