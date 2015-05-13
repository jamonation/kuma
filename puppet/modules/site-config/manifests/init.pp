#
# Configure everything necessary for the site.
#

class site-config {
    file {
        "/home/vagrant/src/media/uploads":
            target => "/home/vagrant/uploads",
            ensure => link,
            require => [ File["/home/vagrant/uploads"] ];
        "/home/vagrant/src/webroot/.htaccess":
            ensure => link,
            target => "/home/vagrant/src/configs/htaccess";
        "/var/www/.htaccess":
            ensure => link,
            target => "/home/vagrant/src/configs/htaccess";
    }
    exec {
        "kuma_update_product_details":
            user => "vagrant",
            cwd => "/home/vagrant/src",
            command => "/home/vagrant/env/bin/python ./manage.py update_product_details",
            timeout => 1200, # Too long, but this can take awhile
            creates => "/home/vagrant/product_details_json/firefox_versions.json",
            require => [
                File["/home/vagrant/product_details_json"]
            ];
        "kuma_django_syncdb":
            user => "vagrant",
            cwd => "/home/vagrant/src",
            command => "/home/vagrant/env/bin/python manage.py syncdb --noinput",
            require => [ Exec["kuma_update_product_details"],
                Service["mysql"], File["/home/vagrant/logs"] ];
        "kuma_south_migrate":
            user => "vagrant",
            cwd => "/home/vagrant/src",
            command => "/home/vagrant/env/bin/python manage.py migrate --noinput",
            require => [ Exec["kuma_django_syncdb"] ];
        "kuma_update_feeds":
            user => "vagrant",
            cwd => "/home/vagrant/src",
            command => "/home/vagrant/env/bin/python ./manage.py update_feeds",
            onlyif => "/usr/bin/mysql -B -uroot kuma -e'select count(*) from feeder_entry' | grep '0'",
            require => [ Exec["kuma_south_migrate"] ];
        "kuma_index_database":
            user => "vagrant",
            cwd => "/home/vagrant/src",
            command => "/home/vagrant/env/bin/python manage.py reindex -p 5 -c 250",
            timeout => 600,
            require => [ Service["elasticsearch-kuma"], Exec["kuma_south_migrate"] ];
    }
}
