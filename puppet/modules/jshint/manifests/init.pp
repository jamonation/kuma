# Get jshint
class jshint {
    exec { 'jshint-install':
        command => '/usr/bin/npm install -gf jshint',
        creates => '/usr/local/bin/jshint',
        require => [
            File['/usr/local/bin/node'],
        ]
    }
    file { '/usr/local/bin/jshint':
        require => Exec['jshint-install'],
    }
}
