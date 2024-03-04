# Puppet manifest to install and configure Nginx web server
class nginx {
  package { 'nginx':
    ensure  => 'latest',
    require => Package['curl'],
  }

  file { '/var/www/html/index.html':
    content => 'Hello World!',
    require => Package['nginx'],
  }

  file { '/etc/nginx/sites-available/default':
    content => template('nginx/default.erb'),
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure    => 'running',
    enable    => true,
    require   => [File['/var/www/html/index.html'], File['/etc/nginx/sites-available/default']],
    subscribe => Package['nginx'],
  }
}

class redirect {
  package { 'curl':
    ensure => 'latest',
  }

  exec { 'create_redirect':
    command  => '/bin/bash -c "echo \"location /redirect_me { return 301 http://$host/new_path; }\" > /etc/nginx/sites-available/default"',
    unless   => '/bin/bash -c "cat /etc/nginx/sites-available/default | grep -q /redirect_me"',
    require  => Package['nginx'],
    subscribe => Package['nginx'],
    notify   => Service['nginx'],
  }
}

include nginx
include redirect
