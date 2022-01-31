require "thor"

module Lambdagem

  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "build NAME", "build gem"
    long_desc Help.text(:build)
    def build(name)
      Build.new(name, options).build
    end

    desc "package NAME", "package gem into tarball"
    long_desc Help.text(:package)
    def package(name)
      Package.new(name, options).build
    end

    desc "upload NAME", "uploads gem to s3"
    long_desc Help.text(:upload)
    option :s3, required: true, desc: "s3 bucket name"
    def upload(name)
      Upload.new(name, options).upload
    end

    desc "all NAME", "builds, packages and uploads to s3"
    long_desc Help.text(:all)
    option :s3, required: true, desc: "s3 bucket name"
    def all(name)
      build(name)
      package(name)
      upload(name)
    end

    extract_options = Proc.new do
      option :s3, required: true, desc: "s3 bucket name", default: "lambdagems"
      option :clean, type: :boolean, desc: "remove the cache"
    end

    desc "extract_gem NAME", "downloads gem from s3 and extracts it"
    long_desc Help.text(:extract)
    extract_options.call
    def extract_gem(name)
      Extract::Gem.new(name, options.merge(exit_on_error: true)).run
    end

    desc "extract_ruby NAME", "downloads ruby from s3 and extracts it"
    long_desc Help.text(:extract_ruby)
    extract_options.call
    def extract_ruby(name)
      Extract::Ruby.new(name, options.merge(exit_on_error: true)).run
    end

    desc "clean", "cleans up tmp/downloads cache"
    long_desc Help.text(:clean)
    def clean
      Clean.new(options).run
    end
  end
end
