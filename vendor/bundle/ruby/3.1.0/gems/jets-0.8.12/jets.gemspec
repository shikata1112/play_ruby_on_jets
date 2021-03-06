# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jets/version"

Gem::Specification.new do |spec|
  spec.name          = "jets"
  spec.version       = Jets::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tongueroo@gmail.com"]
  spec.summary       = "Ruby Serverless Framework on AWS Lambda"
  spec.description   = "Jets is a framework that allows you to create serverless applications with a beautiful language: Ruby. It includes everything required to build an application and deploy it to AWS Lambda. Jets makes serverless accessible to everyone."
  spec.homepage      = "http://rubyonjets.com"
  spec.license       = "MIT"

  vendor_files       = Dir.glob("vendor/**/*")
  gem_files          = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|docs)/})
  end
  spec.files         = gem_files + vendor_files
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "hashie"
  spec.add_dependency "colorize"
  spec.add_dependency "activesupport", ">= 5.2.1"
  spec.add_dependency "actionview", ">= 5.2.1"
  spec.add_dependency "actionpack", ">= 5.2.1"
  spec.add_dependency "activerecord", ">= 5.2.1"
  spec.add_dependency "railties", ">= 5.2.1" # ActiveRecord database_tasks.rb require this
  spec.add_dependency "dotenv"

  spec.add_dependency "recursive-open-struct"
  spec.add_dependency "aws-sdk-s3"
  spec.add_dependency "aws-sdk-cloudformation"
  spec.add_dependency "aws-sdk-cloudwatchlogs"
  spec.add_dependency "aws-sdk-dynamodb"
  spec.add_dependency "aws-sdk-lambda"
  spec.add_dependency "kramdown"
  spec.add_dependency "memoist"
  spec.add_dependency "text-table"
  spec.add_dependency "rack"
  spec.add_dependency "json"
  spec.add_dependency "mimemagic"

  # TODO: only load the database adapters that app's Gemfile instead of jets.gemspec
  spec.add_dependency "pg", "=0.21"

  spec.add_dependency "gems" # lambdagem dependency

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  # ruby_dep-1.5.0 requires ruby version >= 2.2.5, which is incompatible with the current version, ruby 2.2.2p95
  # spec.add_development_dependency "guard"
  # spec.add_development_dependency "guard-bundler"
  # spec.add_development_dependency "guard-rspec"
  # spec.add_development_dependency "codeclimate-test-reporter", group: :test, require: nil
end
