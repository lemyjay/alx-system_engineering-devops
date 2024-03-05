# Puppet manifest to install and configure Nginx web server

# Run apt-get update
exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}

# Install nginx
package { 'nginx':
  ensure  => installed,
  require => Exec['apt-update'],
}

# Create a new index.html
file { 'Create index.html':
  require => Package['nginx'],
  path    => '/var/www/html/index.html',
  content => 'Hello World!\n'
}

# Create a new error page
file { 'Create 404.html':
  require => Package['nginx'],
  path    => '/var/www/html/404.html',
  content => 'Ceci n\'est pas une page\n'
}

file { '/etc/nginx/sites-available/default':
  content => "server {
		listen 80 default_server;
		server_name _;
		root /var/www/html;
		location / {
		index index.html;
          	}
		rewrite ^/redirect_me https://www.youtube.com/watch?v=QH2-TGUlwu4 permanent;
	}",
  require => Exec['nginx'],
}

exec { 'run':
  command  => 'sudo service nginx restart',
  provider => shell,
  require  => [
    File['/etc/nginx/sites-available/default'],
    Package['nginx'],
  ],
}
