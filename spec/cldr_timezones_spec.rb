# encoding: utf-8
require "spec_helper"


describe Cldr::Timezones do
  it "has a VERSION" do
    Cldr::Timezones::VERSION.should =~ /^[\.\da-z]+$/
  end

  describe ".list" do
    it "raises error if not locale is passed" do
      expect{Cldr::Timezones.list(nil)}.to raise_error(ArgumentError, "Locale cannot be blank")
    end
  end

  describe ".load_timezones" do
    it "raises argument error if locale is not supported" do
      expect{Cldr::Timezones.load_timezones("blah")}.to raise_error(ArgumentError, "Locale is not supported")
    end

    it "loads timezone file if locale is supported" do
      expect{Cldr::Timezones.load_timezones("es")}.to_not raise_error
    end
  end

  describe ".build_list" do
    it "builds a list with translations" do
      timezones = Cldr::Timezones.list("es")
      timezones["America/Merida"].should match(/\(GMT-06:00\) Mérida/)
      timezones["America/Sao_Paulo"].should match(/\(GMT-02:00\) São Paulo/)
    end
  end
end
