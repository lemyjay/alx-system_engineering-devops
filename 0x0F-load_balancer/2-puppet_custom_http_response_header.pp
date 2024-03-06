# Puppet manifest to install and configure Nginx web server

# Run apt-get update
exec { 'apt-update':
  command => '/usr/bin/apt-get update'
}

# Install HAProxy
package { 'haproxy':
  ensure  => installed,
  require => Exec['apt-update'],
}

# Run for first time
exec { 'run':
  command => 'sudo service haproxy start',
  provider => shell,
  require => Package['haproxy']
}

# Editing the required files to be able to meet the requirements
file { '/etc/haproxy/haproxy.cfg':
  require => Package['haproxy'],
  path => '/etc/haproxy/haproxy.cfg',
  content => "
global
        log /dev/log    local0
        log /dev/log    local1 notice
        chroot /var/lib/haproxy
        stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
        stats timeout 30s
        user haproxy
        group haproxy
        daemon

        # Default SSL material locations
        ca-base /etc/ssl/certs
        crt-base /etc/ssl/private

        # See: https://ssl-config.mozilla.org/#server=haproxy&server-version=2.0.3&config=intermediate
        ssl-default-bind-ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
        ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
        ssl-default-bind-options ssl-min-ver TLSv1.2 no-tls-tickets

defaults
        log     global
        mode    http
        option  httplog
        option  dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
        errorfile 400 /etc/haproxy/errors/400.http
        errorfile 403 /etc/haproxy/errors/403.http
        errorfile 408 /etc/haproxy/errors/408.http
        errorfile 500 /etc/haproxy/errors/500.http
        errorfile 502 /etc/haproxy/errors/502.http
        errorfile 503 /etc/haproxy/errors/503.http
        errorfile 504 /etc/haproxy/errors/504.http


frontend http_front
    bind *:80
    mode http
    default_backend http_back

backend http_back
    balance roundrobin
    server web-01 491649-web-01:80 check
    server web-02 491649-web-02:80 check

  ",
  ensure => present
}

# Updating the hosts file so it is able to resolve the server names to their IPs
file { '/etc/hosts':
  require => [
    Package['haproxy'],
    File['/etc/haproxy/haproxy.cfg']
  ],
  path => '/etc/hosts',
  content => "
127.0.0.1       localhost
54.210.47.110   491649-lb-01
100.26.252.88   491649-web-02
100.25.0.107    491649-web-01

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts

",
  ensure => present
}

file { '/etc/default/haproxy':
  ensure  => present,
  content => '
# Defaults file for HAProxy
#
# This is sourced by both, the initscript and the systemd unit file, so do not
# treat it as a shell script fragment.

# Change the config file location if needed
#CONFIG="/etc/haproxy/haproxy.cfg"

# Add extra flags here, see haproxy(1) for a few options
#EXTRAOPTS="-de -m 16"
ENABLED=1
',
}


# Restarts the service after all those changes have been made
exec { 're-run':
  command  => 'sudo systemctl restart haproxy',
  provider => shell,
  require  => [
    Exec['run'],
    File['/etc/haproxy/haproxy.cfg'],
    File['/etc/hosts'],
    File['/etc/default/haproxy'],
    Package['haproxy'],
  ],
}
