# -*- encoding: utf-8 -*-
require File.expand_path( '../lib/djvu-tools/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Evan Boyd Sosenko']
  gem.email         = ['razorx@evansosenko.com']
  gem.description   = %q{Ruby toolbox for manipulating DjVu files.}
  gem.summary       = %q{Ruby library for djvused. Currenly tools include: easy page title management for page number generation.}
  gem.homepage      = "http://evansosenko.com"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'djvu-tools'
  gem.require_paths = ['lib']
  gem.platform      = Gem::Platform::RUBY
  gem.version       = DjVuTools::VERSION

  gem.add_dependency 'roman-numerals'
  gem.add_dependency 'which'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'bump'

  gem.requirements  << 'djvused'
end
