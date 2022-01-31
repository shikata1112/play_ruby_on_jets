class Lambdagem::Package < Lambdagem::Base
  def build
    # cd tmp/artifacts
    # tar czf byebug-9.1.0.tgz -C byebug-9.1.0 .
    command = "cd #{@artifacts_root} && tar czf #{tarball_name} -C #{full_gem_name} ."
    puts "=> #{command}"
    system(command)
    tarball_path = "#{@artifacts_root}/#{tarball_name}"
    puts "Tarball files: #{@artifacts_root}/#{full_gem_name}/bundled"
    puts "Tarball created: #{tarball_path.colorize(:green)}"
    puts "Tarball contains the bundled folder with the original path structure."
    puts "Extracting it out would produce: #{example_leaf_path}"
  end

  def example_leaf_path
    # quicker to get the example leaf path using build_root
    leaf_path = Dir.glob("#{@build_root}/bundled/gems/ruby/*/gems/#{full_gem_name}").first
    leaf_path.sub("#{@build_root}/", "") + ' ...'
  end

  def tarball_name
    "#{full_gem_name}-#{RUBY_PLATFORM}.tgz"
  end

  # Since user can build without the version number.
  # check file system for actual gem that was produced to get the version number.
  def full_gem_name
    path = Dir.glob("#{@artifacts_root}/#{@name}*").select do |path|
      File.directory?(path)
    end.first
    full_gem_name = File.basename(path)
  end
end
