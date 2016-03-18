# == Class: tscached::init
#
# === Params
#
# [*enable*]
# package state: true or false (running or stopped)
#
# [*package_version*]
# package version, defaults to latest.
#
# [*webapp_port*]
# port for tscached to listen on, defaults to 8008.
#
# [*redis_host*]
# host running redis server, defaults to localhost.
#
# [*redis_port*]
# port redis listens on, defaults to 6379.
#
# [*kairosdb_host*]
# host running kairosdb, defaults to localhost.
#
# [*kairosdb_port*]
# port kairosdb listens on, defaults to 8080.
#
# [*num_processes*]
# how many uWSGI processes, defaults to 4.
#
# [*num_threads*]
# how many uwsgi threads, defaults to 8.
#
class tscached (
  $enable          = true,
  $package_version = 'latest',
  $webapp_port     = 8008,
  $redis_host      = 'localhost',
  $redis_port      = 6379,
  $kairosdb_host   = 'localhost',
  $kairosdb_port   = 8080,
  $num_processes   = 4,
  $num_threads     = 8,
) {

  if $enable == true {
    $ensure = 'running'
  } else {
    $ensure = 'stopped'
  }

  package { 'tscached':
    ensure      => $package_version,
    configfiles => 'keep',
  } ->
  file { '/etc/tscached.uwsgi.ini':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['tscached'],
    content => template('tscached/tscached.uwsgi.ini.erb'),
  } ->
  file { '/etc/tscached.yaml':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['tscached'],
    content => template('tscached/tscached.yaml.erb'),
  } ->
  service { 'tscached':
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    subscribe  => [
      Package['tscached'],
      File['/etc/tscached.uwsgi.ini'],
      File['/etc/tscached.yaml'],
    ],
  }

}
