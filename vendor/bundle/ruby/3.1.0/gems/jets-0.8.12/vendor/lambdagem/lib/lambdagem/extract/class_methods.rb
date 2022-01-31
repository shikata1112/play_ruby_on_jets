require "net/http"

module Lambdagem::Extract::ClassMethods
  # Exits early if not all the linux gems are available
  # It better to error now then later on Lambda
  # Provide users with instructions on how to compile gems
  #
  # We check all the availability before even downloading so we can provide a
  # full list of gems they might want to research all at once instead of incrementally
  def check_availability(gems)
    availabilities = gems.inject({}) do |hash, gem_name|
      exist = url_exists?(gem_url(gem_name))
      hash[gem_name] = exist
      hash.merge(hash)
    end

    all_available = availabilities.values.all? {|v| v }
    unless all_available
      puts "Your project requires some pre-compiled Linux gems that are not yet available as a pre-compiled lambda gem.  The build process will not continue because there's no point wasting your time deploying to Lambda and finding out later."
      puts "The unavailable gems are:"
      availabilities.each do |gem_name, available|
        next if available
        puts "  #{gem_name}"
      end
      puts <<-EOL
How to fix this:

  1. Build your jets project on an Amazon Lambda based EC2 Instance and compile your own gems with the proper shared libaries.
  2. Configure jets to lookup your own pre-compiled gems url.
  3. Add the the required gems to boltopslabs/lambdagems and submit a pull request.

More info: http://lambdagems.com
EOL
      exit
    end
  end

  # Example url:
  #   https://gems.lambdagems.com/gems/2.5.0/byebug/byebug-9.1.0-x86_64-linux.tgz
  def url_exists?(url)
    url = URI.parse(url)
    req = Net::HTTP.new(url.host, url.port).tap do |http|
      http.use_ssl = true
    end
    res = req.request_head(url.path)
    res.code == "200"
  rescue SocketError, OpenURI::HTTPError
    false
  end
end
