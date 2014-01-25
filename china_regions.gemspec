# encoding: utf-8
require File.expand_path('../lib/china_regions/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Encore Shao","Trey Springer"]
  gem.email         = ["encore.shao@gmail.com","dspringer@enova.com"]
  gem.description   = %q{China regions Ruby on rails interface}
  gem.summary       = %q{Rails 4 version of dropdowns for all provinces, cities, and districts in China.}
  gem.homepage      = "http://github.com/encoreshao"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "china_regions"
  gem.require_paths = ["lib"]
  gem.version       = ChinaRegions::VERSION

  gem.add_dependency 'jquery-rails'
end
