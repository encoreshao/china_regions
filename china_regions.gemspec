
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

  gem.add_dependency 'down'
  gem.add_dependency 'jquery-rails'
  gem.add_dependency 'ruby-pinyin'
  gem.add_development_dependency 'coveralls'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
end
