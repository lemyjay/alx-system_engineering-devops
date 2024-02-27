# Install Flask version 2.1.0
package { 'flask':
  ensure   => '2.1.0',
  provider => 'pip3',
}

# Install the latest version of Werkzeug
package { 'werkzeug':
  ensure   => 'latest',
  provider => 'pip3',
}