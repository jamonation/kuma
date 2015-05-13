# Get uglify
class uglify {
    exec { 'uglify-install':
        command => '/usr/bin/npm install -gf uglify-js@2.4.13',
        creates => '/usr/local/bin/uglifyjs',
        require => [
            File['/usr/local/bin/node'],
        ]
    }
}
