# Get csslint
class csslint {
    exec { 'csslint-install':
        command => '/usr/bin/npm install -gf csslint@0.10.0',
        creates => '/usr/local/bin/csslint',
        require => [
            File['/usr/local/bin/node'],
        ]
    }
    file { '/usr/local/bin/csslint':
        require => Exec['csslint-install'],
    }
}
