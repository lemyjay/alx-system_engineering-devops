# Set up SSH client configuration
file { '/home/vagrant/.ssh/config':
  ensure  => file,
  content => template('ssh/config.erb'),
  owner   => 'vagrant',
  group   => 'vagrant',
  mode    => '0600',
}

# Disable password authentication
file_line { 'Turn off passwd auth':
  line   => 'PasswordAuthentication no',
  path   => '/home/vagrant/.ssh/config',
  match  => '^PasswordAuthentication.*$',
}

# Declare identity file
file_line { 'Declare identity file':
  line   => 'IdentityFile ~/.ssh/school',
  path   => '/home/vagrant/.ssh/config',
  match  => '^IdentityFile.*$',
}

