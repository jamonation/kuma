# Get foreman up and running
class foreman {
    package { "foreman":
        ensure   => '0.63.0',
        provider => gem,
    }
    package { "ruby-posix-spawn":
        ensure   => present
    }
}