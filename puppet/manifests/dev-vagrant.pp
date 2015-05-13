#
# Dev server for MDN
#

include apt

$DB_NAME = "kuma"
$DB_USER = "kuma"
$DB_PASS = "kuma"

Exec {
    # This is what makes all commands spew verbose output
    logoutput => true
}

# general good stuff
include basics
include apache2
include apache2::config
include foreman
include memcached
include mysql
include mysql::config
include rabbitmq
include rabbitmq::config

# node stuff
include nodejs
include cleancss
include csslint
include jshint
include stylus
include uglify

# python stuff
# include python