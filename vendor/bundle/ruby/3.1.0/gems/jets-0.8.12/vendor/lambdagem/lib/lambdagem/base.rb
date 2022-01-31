require 'fileutils'
require 'colorize'

class Lambdagem::Base
  include Lambdagem::Util

  attr_reader :s3_bucket, :lambdagems_url
  def initialize(name, options={})
    @name = name
    @options = options

    @build_root = options[:build_root] || "/tmp/lambdagem"
    @artifacts_root = "#{@build_root}/artifacts"
    @s3_bucket = options[:s3] || 'lambdagems'
    @lambdagems_url = options[:lambdagems_url] || "https://gems.lambdagems.com"
  end

  # The gems are stored in a ruby version folder that always has a patch version of
  # 0.  So 2.5.1 => 2.5.0
  def minor_ruby_version
    major, minor = RUBY_VERSION.split('.')[0..1]
    [major, minor, "0"].join('.')
  end

  # The ruby version folder always has a 0 for the patch version.
  # Example: 2.4.2 => 2.4.0
  def ruby_version_folder
    major, minor, patch = RUBY_VERSION.split('.')
    [major, minor, '0'].join('.')
  end

  # Current jets version is 2.5.0, will use that for gems and ruby
  # when users are using ruby 2.5.1.
  # When the jets ruby version is updated we update this also.
  def jets_ruby_version
    major, minor, patch = RUBY_VERSION.split('.')
    [major, minor, '0'].join('.')
  end

  # Input: byebug-9.1.0
  # Output: byebug
  def gem_name
    @name.gsub(/-(\d+\.\d+\.\d+.*)/,'')
  end

  # Input: byebug-9.1.0
  # Output: 9.1.0
  # Can return nil if version not found
  def gem_version
    md = @name.match(/-(\d+\.\d+\.\d+.*)/)
    md[1] if md
  end
end
