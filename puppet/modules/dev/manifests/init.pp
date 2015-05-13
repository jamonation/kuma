# dev class
class dev {
    apt::key { 'elasticsearch':
      key => 'D88E42B4',
      key_source => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch',
    }
    class { 'elasticsearch':
      package_url => 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.7.deb',
      java_install => true,
      java_package => 'openjdk-7-jre-headless',
    }

    elasticsearch::instance { 'kuma':
      datadir => '/var/lib/elasticsearch',
      config => {
        'node' => {
          'name' => 'kuma'
        },
        'index' => {
          'number_of_replicas' => '0',
          'number_of_shards'   => '1'
        },
        'network' => {
          'host' => '0.0.0.0'
        },
        'discovery.zen.ping' => {
            'multicast.enabled' => false,
            'unicast.hosts' => ['0.0.0.0']
        }
      },
    }


    elasticsearch::plugin{'mobz/elasticsearch-head':
      module_dir => 'head',
      instances => ['kuma'],
    }

}
