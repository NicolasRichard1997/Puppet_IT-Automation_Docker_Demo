exec { 'apt-update':
  command => '/usr/bin/apt-get update',
}

package { 'cowsay':
  ensure => present,
  require => Exec['apt-update'],
}
