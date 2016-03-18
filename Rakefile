require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-syntax'
PuppetSyntax.future_parser = true
Rake::Task["default"].clear
task :default => [ :syntax, :spec ]
