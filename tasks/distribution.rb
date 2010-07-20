require 'jeweler'
require 'yard'

YARD::Rake::YardocTask.new

Jeweler::Tasks.new do |gem|
  gem.name        = "lu-tze"
  gem.summary     = %Q{Sends backups to Historian}
  gem.description = %Q{}
  gem.email       = 'pat@freelancing-gods.com'
  gem.homepage    = 'http://github.com/freelancing-god/lu-tze'
  gem.authors     = ["Pat Allan"]
  
  gem.add_dependency 'activerecord', '>= 2.3.5'
  gem.add_dependency 'rest-client',  '>= 1.4.2'
  
  gem.add_development_dependency 'rspec', '>= 1.3.0'
  gem.add_development_dependency 'yard',  '>= 0'
  
  gem.files = FileList[
    'lib/**/*.rb',
    'LICENCE',
    'README.textile'
  ]
  # gem is a Gem::Specification...
  # See http://www.rubygems.org/read/chapter/20 for additional settings
end

Jeweler::GemcutterTasks.new
