# encoding: utf-8
require File.expand_path('../lib/china_region/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Encore Shao"]
  gem.email         = ["encore.shao@gmail.com"]
  gem.description   = %q{China region Ruby on rails interface}
  gem.summary       = %q{China region Ruby on rails interface}
  gem.homepage      = "http://github.com/encoreshao"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "china_region"
  gem.require_paths = ["lib"]
  gem.version       = ChinaRegion::VERSION
  
  gem.add_dependency 'jquery-rails'
end
