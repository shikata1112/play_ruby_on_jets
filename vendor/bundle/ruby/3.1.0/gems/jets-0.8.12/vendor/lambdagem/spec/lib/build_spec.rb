require "spec_helper"

describe Lambdagem::Build do
  let(:builder) do
    Lambdagem::Build.new(gem, s3: "lambdagems")
  end

  context("gem with version number") do
    let(:gem) { "byebug-9.1.0" }

    it "gem info" do
      expect(builder.gem_name).to eq "byebug"
      expect(builder.gem_version).to eq "9.1.0"
    end
  end

  context("gem without version number") do
    let(:gem) { "byebug" }

    it "gem info" do
      expect(builder.gem_name).to eq "byebug"
      expect(builder.gem_version).to eq nil
    end

    it "create_gemfile" do
      builder.create_gemfile
      content = IO.read("/tmp/lambdagem/Gemfile")
      expect(content).to include("byebug")
      expect(content).not_to include("9.1.0")
    end
  end
end
