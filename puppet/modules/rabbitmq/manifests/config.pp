# rabbitmq config
class rabbitmq::config {
    exec {
        'rabbitmq-kuma-user':
            require => [ Package['rabbitmq-server'], Service['rabbitmq-server'] ],
            command => "/usr/sbin/rabbitmqctl add_user kuma kuma",
            unless => "/usr/sbin/rabbitmqctl list_users 2>&1 | grep -q 'kuma'",
            timeout => 300;
        'rabbitmq-kuma-vhost':
            require => [ Package['rabbitmq-server'], Service['rabbitmq-server'],
                         Exec['rabbitmq-kuma-user'] ],
            command => "/usr/sbin/rabbitmqctl add_vhost kuma",
            unless => "/usr/sbin/rabbitmqctl list_vhosts 2>&1 | grep -q 'kuma'",
            timeout => 300;
        'rabbitmq-kuma-permissions':
            require => [ Package['rabbitmq-server'], Service['rabbitmq-server'],
                         Exec['rabbitmq-kuma-user'], Exec['rabbitmq-kuma-vhost'] ],
            command => "/usr/sbin/rabbitmqctl set_permissions -p kuma kuma '.*' '.*' '.*'",
            unless => "/usr/sbin/rabbitmqctl list_permissions -p kuma 2>&1 | grep -v 'vhost' | grep -q 'kuma'",
            timeout => 300;
    }
}