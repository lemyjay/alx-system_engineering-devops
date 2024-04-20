# Puppet manifest to change OS configuration for the holberton user

exec { 'increase_open_files_limit':
  command => 'ulimit -n 10000',
  user    => 'holberton',
}
