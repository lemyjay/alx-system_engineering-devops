# Using Puppet to install flask from pip3 with the requiremnts in there
package { 'flask':
ensure   => '2.1.0',
provider => 'pip3'
}
