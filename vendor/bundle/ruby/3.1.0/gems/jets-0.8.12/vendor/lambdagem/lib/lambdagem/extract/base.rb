require "open-uri"

module Lambdagem::Extract
  autoload :ClassMethods, 'lambdagem/extract/class_methods'

  class Base < Lambdagem::Base
    extend ClassMethods

    def clean_downloads(folder)
      path = "#{@build_root}/downloads/#{folder}"
      say "Removing cache: #{path}"
      FileUtils.rm_rf(path)
    end

    def unpack_tarball(tarball_path)
      dest = project_root
      say "Unpacking into #{dest}"
      FileUtils.mkdir_p(dest)
      untar(tarball_path, dest)
    end

    def untar(tarball_path, parent_folder_dest)
      sh("tar -xzf #{tarball_path} -C #{parent_folder_dest}")
    end

    def sh(command)
      say "=> #{command}".colorize(:green)
      success = system(command)
      abort("Command Failed") unless success
      success
    end

    def url_exists?(url)
      self.class.url_exists?(url)
    end

    # Returns the dest path
    def download_file(source_url, dest)
      say "Url #{source_url}"
      return unless url_exists?(source_url)

      if File.exist?(dest)
        say "File already downloaded #{dest}"
        return dest
      end

      say "Downloading..."
      FileUtils.mkdir_p(File.dirname(dest)) # ensure parent folder exists

      File.open(dest, 'wb') do |saved_file|
        open(source_url, 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end
      dest
    end

    def project_root
      @options[:project_root] || "."
    end
  end
end
