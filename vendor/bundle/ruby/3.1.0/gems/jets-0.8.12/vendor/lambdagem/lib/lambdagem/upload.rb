require 'aws-sdk-s3'

class Lambdagem::Upload < Lambdagem::Base
  def upload
    # s3_path: s3://boltops-gems/gems/2.4.1/byebug/byebug-9.1.0-x86_64-darwin16.tar.gz
    puts "Uploading #{tarball_path.inspect} to #{s3_path(tarball_path)}"

    # raise "Not uploading because on macosx" if RUBY_PLATFORM =~ /darwin/ && !ENV['LAMBDAGEM_MAC_TEST']
    # return if ENV['TEST']

    key = s3_key(tarball_path)
    obj = s3_resource.bucket(@s3_bucket).object(key)
    # use LAMBDAGEM_S3_ACL=private to make private
    acl = ENV['LAMBDAGEM_S3_ACL'] || "public-read" # default
    obj.upload_file(tarball_path, acl: acl)
  end

  def tarball_path
    path = Dir.glob("#{@artifacts_root}/#{@name}*-#{RUBY_PLATFORM}.tgz").select do |path|
      File.file?(path)
    end.first
  end

  def s3_path(tarball_path)
    "s3://#{@s3_bucket}/#{s3_key(tarball_path)}"
  end

  # Example tarball_path: tmp/artifacts/pg-0.21.0/pg-0.21.0-x86_64-linux.tgz
  def s3_key(tarball_path)
    tarball = File.basename(tarball_path)
    gem_folder = tarball.gsub(/-\d+\.\d+\.\d+.*/,'')
    full_gem_name = tarball.sub(/-x86_.*/,'') # -x86_...
    "gems/#{RUBY_VERSION}/#{gem_folder}/#{tarball}"
  end

  def s3_resource
    @s3_resource ||= Aws::S3::Resource.new
  end
end
