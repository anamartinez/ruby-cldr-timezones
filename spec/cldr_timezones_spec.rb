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

  describe ".build_list" do
    it "builds a list with translations" do
      timezones = Cldr::Timezones.list(:es)
      timezones["Europe/Moscow"].should eq("(GMT+04:00) Moscú")
      timezones["America/Sao_Paulo"].should eq("(GMT-02:00) São Paulo")
    end

    it "builds a list with meaningful subset" do
      timezones = Cldr::Timezones.list(:ja)
      timezones.size.should equal(124)
    end

    it "builds the complete set if true is passed" do
      timezones = Cldr::Timezones.list(:ja, true)
      timezones.size.should equal(581)
    end
  end

  describe ".load_timezones_translations" do
    it "raises argument error if locale is not supported" do
      expect{Cldr::Timezones.send(:load_timezones_translations, "blah")}.to raise_error(ArgumentError, "Locale is not supported")
    end

    it "loads timezone file if locale is supported" do
      expect{Cldr::Timezones.send(:load_timezones_translations, "es")}.to_not raise_error
    end
  end

  describe ".seconds_to_utc_offset" do
    it "returns a possitive offset" do
      #Asia/Sakhalin timezone
      offset = Cldr::Timezones.send(:seconds_to_utc_offset, 39600)
      offset.should eq("+11:00")
    end

    it "returns a negative offset" do
      #US/Indiana-Starke timezone
      offset = Cldr::Timezones.send(:seconds_to_utc_offset, -21600)
      offset.should eq("-06:00")
    end

    it "returns a zero offset" do
      #Zulu timezone
      offset = Cldr::Timezones.send(:seconds_to_utc_offset, 0)
      offset.should eq("+00:00")
    end
  end
end
