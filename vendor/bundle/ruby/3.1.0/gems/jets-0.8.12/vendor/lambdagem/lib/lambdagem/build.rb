require 'bundler'

# Terms:
#   name: the gem name the user passed in, could have version number could not
#   full_gem_name: has both gem name and version number.  IE: byebug-0.9.1
#   gem_name: strips the version. IE: byebug
#   gem_version: version only. IE: 0.9.1
class Lambdagem::Build < Lambdagem::Base
  def build
    puts "Building #{@name} in #{@build_root}"
    return if @options[:noop]

    clean
    create_gemfile
    bundle_install
    # upload not just the top-level gem but also the dependent gems
    # in case there are dependent gems that also require compilation
    all_gems.each do |full_gem_name|
      artifact_location = prepare_gem(full_gem_name)
      # artifact is going to be tmp/artifacts/bundled
      # the article contains the bundled directory so we can expand it all
      # out together.
      puts "Artifacts location: #{artifact_location}"
      puts "Gem artifact path:  #{gem_artifact_path(full_gem_name)}"
      puts "If you have system library dependencies add them under the artifacts location before running: lambdagem package #{full_gem_name}"
    end
  end

  def all_gems
    names = all_extensions.map { |path| File.basename(path) }
    names.uniq
  end

  # Finds the paths that have compiled extensions.
  #
  # Examples of return:
  # linux:
  #   ["tmp/bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0"]
  # macosx:
  #   ["tmp/bundled/gems/ruby/2.4.0/extensions/x86_64-darwin-16/2.4.0-static/byebug-9.1.0"]
  def all_extensions
    Dir.glob("#{@build_root}/bundled/gems/ruby/*/extensions/*/*/*").to_a.uniq
  end

  def clean
    FileUtils.rm_rf(@build_root)
  end

  def create_gemfile
    content =<<-EOL
source "https://rubygems.org"
EOL
    if gem_version
      content << %Q|gem "#{gem_name}", "#{gem_version}"\n|
    else
      content << %Q|gem "#{gem_name}"\n|
    end

    gemfile_path = "#{@build_root}/Gemfile"
    FileUtils.mkdir_p(File.dirname(gemfile_path))
    IO.write(gemfile_path, content)
    puts "Generated: #{gemfile_path}"
  end

  def bundle_install
    Bundler.with_clean_env do
      command = "cd #{@build_root} && bundle install --path bundled/gems"
      puts "=> #{command}"
      success = system(command)
      abort('Bundle install failed, exiting.') unless success
    end
  end

  # Do not want to copy everything underneath bundled/gems/ruby/2.5.0 or else
  # we end up with a bunch of extra files that might screw up an current
  # install of ruby when we extract out the files and overwrite things.
  #
  # Instead only copy the folders that we want to be a part of the tarball
  # into another directory first.  This is called the artifacts directory.
  #
  # Example of the 2 folder we want to keep is:
  #
  #   tmp/bundled/gems/ruby/2.5.0/gems/byebug-9.1.0
  #   tmp/bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0
  #
  # Returns the path to the ruby minor version folder that contains all the of gem.
  # Example: tmp/artifacts/2.5.0
  def prepare_gem(full_gem_name)
    gem_path = built_gem_path(full_gem_name)
    ext_path = built_ext_path(full_gem_name)
    copy_artifacts(gem_path)
    copy_artifacts(ext_path) if ext_path
    # copy specifications: required for bundler to work
    specs_path = specifications_path(full_gem_name)
    copy_spec(specs_path)

    tidy_gem(full_gem_name)

    "#{@artifacts_root}/#{full_gem_name}/bundled"
  end

  # Clean up some unneeded files to try to keep the package size down
  def tidy_gem(full_gem_name)
    gem_artifact_path = gem_artifact_path(full_gem_name)

    # remove top level tests and cache folders
    Dir.glob("#{gem_artifact_path}/*").each do |path|
      next unless File.directory?(path)
      folder = File.basename(path)
      if %w[test tests spec features benchmark cache doc].include?(folder)
        FileUtils.rm_rf(path)
      end
    end

    Dir.glob("#{gem_artifact_path}/**/*").each do |path|
      next unless File.file?(path)
      ext = File.extname(path)
      if %w[.rdoc .md .markdown].include?(ext) or
         path =~ /LICENSE|CHANGELOG|README/
        FileUtils.rm_f(path)
      end
    end
  end

  def gem_artifact_path(full_gem_name)
    "#{@artifacts_root}/#{full_gem_name}/bundled/gems/ruby/#{ruby_version_folder}/gems/#{full_gem_name}"
  end

  # original_path example: tmp/bundled/gems/ruby/2.5.0/gems/byebug-9.1.0
  def copy_artifacts(original_path)
    leaf_path = recreate_leaves_structure(@artifacts_root, original_path)
    FileUtils.cp_r(original_path, leaf_path)
  end

  # Mirrors the some of the leave path structure of the original structure.
  # This works for specific folders that have the gem name at the end only.
  # This is not a generic method.
  #
  # Example 1:
  #   dest: tmp/artifacts
  #   original_path: tmp/bundled/gems/ruby/2.5.0/gems/byebug-9.1.0
  #
  # Recreated structure:
  #   created: tmp/artifacts/byebug-9.1.0/bundled/gems/ruby/2.5.0/gems
  #
  # Example 2:
  #   dest: tmp/artifacts
  #   original_path: tmp/bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0
  #
  # Recreated structure:
  #   created: tmp/artifacts/byebug-9.1.0/bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static
  #
  #
  # Returns created leaf path folder.  If the original path was a file this
  # will be the parent folder.
  #
  # Example:
  #
  #   folder/a.txt => leaf path is folder
  #   folder/folder2 => leaf path is folder/folder2
  #
  def recreate_leaves_structure(dest_dir, original_path)
    # strip the leading tmp/bundled/gems/ruby/
    # and the trailing gem_name
    full_gem_name = File.basename(original_path)
    new_path = original_path.sub("#{@build_root}/", "") # script build root
    leaf_path = "#{dest_dir}/#{full_gem_name}/#{new_path}"
    leaf_path = File.dirname(leaf_path)
    FileUtils.mkdir_p(leaf_path)
    leaf_path
  end

  #   bundled/gems/ruby/2.5.0/gems/byebug-9.1.0
  def built_gem_path(full_gem_name)
    "#{@build_root}/bundled/gems/ruby/#{minor_ruby_version}/gems/#{full_gem_name}"
  end

  #   bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0
  #                                                      |
  #                                                 could change
  def built_ext_path(full_gem_name)
    # infer the path because think 2.5.0-static can probably change
    # Note, RUBY_PLATFORM x86_64-darwin17 in a Dir.glob patter does not always
    # result in a match
    pattern = "#{@build_root}/bundled/gems/ruby/#{minor_ruby_version}/extensions/*/*/#{full_gem_name}"
    # path should be something like this:
    #   tmp/bundled/gems/ruby/2.5.0/extensions/x86_64-linux/2.5.0-static/byebug-9.1.0
    path = Dir.glob(pattern).first
  end

  def specifications_path(full_gem_name)
    "#{@build_root}/bundled/gems/ruby/#{minor_ruby_version}/specifications/#{full_gem_name}.gemspec"
  end

  def copy_spec(original_path)
    full_gem_name = File.basename(original_path, ".gemspec")
    new_path = original_path.gsub(%r{.*bundled/}, "bundled/") # strip build_root
    new_path = "#{@artifacts_root}/#{full_gem_name}/#{new_path}"
    FileUtils.mkdir_p(File.dirname(new_path))
    FileUtils.cp(original_path, new_path)
  end
end
