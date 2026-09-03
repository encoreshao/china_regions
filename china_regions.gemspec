# frozen_string_literal: true

require File.expand_path('lib/china_regions/version', __dir__)

Gem::Specification.new do |gem|
  gem.name          = 'china_regions'
  gem.authors       = ['Encore Shao']
  gem.email         = ['encore.shao@gmail.com']
  gem.description   = 'China Regions is a Ruby on rails interface'
  gem.summary       = 'Rails 4+ version of dropdowns for all provinces, cities,
                       and districts in China.'
  gem.homepage      = 'https://github.com/encoreshao/china_regions'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.version       = ChinaRegions::VERSION
  gem.required_ruby_version = '>= 2.6'

  gem.add_dependency 'down'
  gem.add_dependency 'jquery-rails'
  gem.add_dependency 'ruby-pinyin'
  gem.add_development_dependency 'appraisal'
  gem.add_development_dependency 'combustion'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rails'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-rails'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'sqlite3'
end
