$:.unshift(File.expand_path("../", __FILE__))
require "lambdagem/version"
require "byebug" if ENV['USER'] == 'tung'

module Lambdagem
  autoload :Command, "lambdagem/command"
  autoload :Help, "lambdagem/help"
  autoload :CLI, "lambdagem/cli"
  autoload :Base, "lambdagem/base"
  autoload :Build, "lambdagem/build"
  autoload :Package, "lambdagem/package"
  autoload :Upload, "lambdagem/upload"
  autoload :Extract, "lambdagem/extract"
  autoload :Clean, "lambdagem/clean"
  autoload :Exist, "lambdagem/exist"
  autoload :Util, "lambdagem/util"
  extend Util
end
