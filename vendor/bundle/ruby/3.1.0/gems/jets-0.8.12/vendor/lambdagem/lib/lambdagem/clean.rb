module Lambdagem
  class Clean < Base
    def run
      FileUtils.rm_rf("#{@build_root}/downloads")
      puts "Cleared out tmp/downloads cache."
    end
  end
end
