# -*- encoding: utf-8 -*-
# stub: jets 0.8.12 ruby lib

Gem::Specification.new do |s|
  s.name = "jets".freeze
  s.version = "0.8.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tung Nguyen".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-09-09"
  s.description = "Jets is a framework that allows you to create serverless applications with a beautiful language: Ruby. It includes everything required to build an application and deploy it to AWS Lambda. Jets makes serverless accessible to everyone.".freeze
  s.email = ["tongueroo@gmail.com".freeze]
  s.executables = ["jets".freeze]
  s.files = ["exe/jets".freeze]
  s.homepage = "http://rubyonjets.com".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.3".freeze
  s.summary = "Ruby Serverless Framework on AWS Lambda".freeze

  s.installed_by_version = "3.3.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<thor>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<hashie>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<colorize>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.2.1"])
    s.add_runtime_dependency(%q<actionview>.freeze, [">= 5.2.1"])
    s.add_runtime_dependency(%q<actionpack>.freeze, [">= 5.2.1"])
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 5.2.1"])
    s.add_runtime_dependency(%q<railties>.freeze, [">= 5.2.1"])
    s.add_runtime_dependency(%q<dotenv>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<recursive-open-struct>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<aws-sdk-s3>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<aws-sdk-cloudformation>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<aws-sdk-cloudwatchlogs>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<aws-sdk-dynamodb>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<aws-sdk-lambda>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<kramdown>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<memoist>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<text-table>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<json>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<mimemagic>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<pg>.freeze, ["= 0.21"])
    s.add_runtime_dependency(%q<gems>.freeze, [">= 0"])
    s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  else
    s.add_dependency(%q<thor>.freeze, [">= 0"])
    s.add_dependency(%q<hashie>.freeze, [">= 0"])
    s.add_dependency(%q<colorize>.freeze, [">= 0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 5.2.1"])
    s.add_dependency(%q<actionview>.freeze, [">= 5.2.1"])
    s.add_dependency(%q<actionpack>.freeze, [">= 5.2.1"])
    s.add_dependency(%q<activerecord>.freeze, [">= 5.2.1"])
    s.add_dependency(%q<railties>.freeze, [">= 5.2.1"])
    s.add_dependency(%q<dotenv>.freeze, [">= 0"])
    s.add_dependency(%q<recursive-open-struct>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk-s3>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk-cloudformation>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk-cloudwatchlogs>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk-dynamodb>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk-lambda>.freeze, [">= 0"])
    s.add_dependency(%q<kramdown>.freeze, [">= 0"])
    s.add_dependency(%q<memoist>.freeze, [">= 0"])
    s.add_dependency(%q<text-table>.freeze, [">= 0"])
    s.add_dependency(%q<rack>.freeze, [">= 0"])
    s.add_dependency(%q<json>.freeze, [">= 0"])
    s.add_dependency(%q<mimemagic>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, ["= 0.21"])
    s.add_dependency(%q<gems>.freeze, [">= 0"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
  end
end
