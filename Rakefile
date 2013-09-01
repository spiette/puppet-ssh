require 'puppetlabs_spec_helper/rake_tasks'
task :default => [:spec, :lint]

desc "Run all tasks prior a release"
task :prerelease => [:spec_prep, :spec_standalone, :spec_clean, :clean ]
