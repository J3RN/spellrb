# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spell/version'

Gem::Specification.new do |spec|
  spec.name          = "spell"
  spec.version       = Spell::VERSION
  spec.authors       = ["Jonathan Arnett"]
  spec.email         = ["jonarnett90@gmail.com"]

  spec.summary       = %q{A customizable spell checker, written in pure Ruby }
  spec.description   = %q{Spell checker written in pure Ruby, implementing a simple bigram comparison algorithm. Spell has no external dependencies (including aspell or ispell). }
  spec.homepage      = "https://github.com/J3RN/spellrb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "ruby-prof"
end
