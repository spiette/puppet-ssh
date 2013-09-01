require 'puppetlabs_spec_helper/rake_tasks'
task :default => [:spec, :lint]

desc "Run all tasks for a release"
task :release => [:spec_prep, :spec_standalone, :spec_clean, :clean, :build ]
