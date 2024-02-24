# Using Puppet to creat a file in /tmp with requiremnts as shown in there
file { '/tmp/school':
ensure  => file,
mode    => '0744',
owner   => 'www-data',
group   => 'www-data',
content => 'I love Puppet',
}
