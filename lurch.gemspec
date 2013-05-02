# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lurch/version'

Gem::Specification.new do |gem|
  gem.name          = "lurch"
  gem.version       = Lurch::VERSION
  gem.authors       = ["Sam Bell"]
  gem.email         = ["samueljamesbell@gmail.com"]
  gem.description   = 'A pragmatic virtual assistant'
  gem.summary       = 'A pragmatic virtual assistant'
  gem.homepage      = "http://github.com/samueljamesbell/lurch"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
