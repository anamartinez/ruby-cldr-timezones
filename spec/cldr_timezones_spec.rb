require "spec_helper"

describe CldrTimezones do
  it "has a VERSION" do
    CldrTimezones::VERSION.should =~ /^[\.\da-z]+$/
  end
end
