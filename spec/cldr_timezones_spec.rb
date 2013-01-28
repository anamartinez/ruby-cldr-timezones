require "spec_helper"

describe Cldr::Timezones do
  it "has a VERSION" do
    Cldr::Timezones::VERSION.should =~ /^[\.\da-z]+$/
  end
end
