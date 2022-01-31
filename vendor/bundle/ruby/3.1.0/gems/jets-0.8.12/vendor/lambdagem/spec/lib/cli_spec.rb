require "spec_helper"

# to run specs with what"s remembered from vcr
#   $ rake
#
# to run specs with new fresh data from aws api calls
#   $ rake clean:vcr ; time rake
describe Lambdagem::CLI do
  before(:all) do
    @args = "--noop"
  end

  describe "lambdagem" do
    it "build" do
      out = execute("exe/lambdagem build byebug-10.0.0 #{@args}")
      expect(out).to include("Building")
    end

    it "extract" do
      out = execute("exe/lambdagem extract_gem byebug-10.0.0 #{@args}")
      expect(out).to include("Looking for byebug")
    end
  end
end
