# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lambdagem/version"

Gem::Specification.new do |spec|
  spec.name          = "lambdagem"
  spec.version       = Lambdagem::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.description   = %q{Gem builder}
  spec.summary       = %q{Gem builder}
  spec.homepage      = "https://github.com/tongueroo/lambdagem"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "hashie"
  spec.add_dependency "colorize"
  spec.add_dependency "aws-sdk-s3"
  spec.add_dependency "gems"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
end
