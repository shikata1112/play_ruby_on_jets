require "spec_helper"

describe Lambdagem::Upload do
  let(:uploader) do
    Lambdagem::Upload.new(gem, s3: "lambdagems")
  end

  context("gem with version number") do
    let(:gem) { "byebug-9.1.0" }

    it "s3_path" do
      s3_path = uploader.s3_path("tmp/gems/ruby/byebug-9.1.0-x86_64-darwin16.tar.gz")
      expect(s3_path).to eq "s3://lambdagems/gems/2.5.1/byebug/byebug-9.1.0-x86_64-darwin16.tar.gz"
    end
  end

  context("gem without version number") do
    let(:gem) { "byebug" }

    it "s3_path" do
      s3_path = uploader.s3_path("tmp/gems/ruby/byebug-9.1.0-x86_64-darwin16.tar.gz")
      expect(s3_path).to eq "s3://lambdagems/gems/2.5.1/byebug/byebug-9.1.0-x86_64-darwin16.tar.gz"
    end
  end
end
