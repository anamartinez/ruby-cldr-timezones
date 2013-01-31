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

    it "builds a list with translations" do
      timezones = Cldr::Timezones.list(:es)
      timezones["Europe/Moscow"].should eq("(GMT+04:00) Moscú")
      timezones["America/Sao_Paulo"].should eq("(GMT-02:00) São Paulo")
    end

    it "builds a list with translations" do
      timezones = Cldr::Timezones.list(:"es-MX", true)
      timezones["America/Indiana/Knox"].should eq("(GMT-06:00) Knox, Indiana")
      timezones["Asia/Saigon"].should eq("(GMT+07:00) Ho Chi Minh")
    end

    # Checks that fallback is working since Moscú is only in "es"
    it "builds a list with translations using fallback" do
      timezones = Cldr::Timezones.list(:"es-MX")
      timezones["Europe/Moscow"].should eq("(GMT+04:00) Moscú")
      timezones["America/Sao_Paulo"].should eq("(GMT-02:00) São Paulo")
    end

    it "builds a list with translations using fallback en-US" do
      timezones = Cldr::Timezones.list(:"en-US")
      timezones["Europe/Moscow"].should eq("(GMT+04:00) Moscow")
      timezones["America/Sao_Paulo"].should eq("(GMT-02:00) Sao Paulo")
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

  describe ".fallback" do
    it "returns nil if locale tag includes only the language tag" do
      Cldr::Timezones.should_not_receive(:load_timezones_translations)
      fallback = Cldr::Timezones.send(:fallback, "en")
      fallback.should  eq(nil)
    end

    it "returns the fallback when the tag includes the region" do
      Cldr::Timezones.should_receive(:load_timezones_translations).with("es")
      Cldr::Timezones.send(:fallback, "es-MX")
    end

    it "returns the fallback when the tag includes the scrip" do
      Cldr::Timezones.should_receive(:load_timezones_translations).with("uz-Latn")
      Cldr::Timezones.send(:fallback, "uz-Latn-UZ")
    end

    it "return nil if the fallback tag is not supported" do
      fallback = Cldr::Timezones.send(:fallback, "blah-blah")
      fallback.should eq(nil)
    end
  end

  describe ".load_timezones_translations" do
    it "raises argument error if locale is blank" do
      expect{Cldr::Timezones.send(:load_timezones_translations, nil)}.to raise_error(ArgumentError, "Locale cannot be blank")
    end

    it "raises argument error if locale is not supported" do
      expect{Cldr::Timezones.send(:load_timezones_translations, "blah")}.to raise_error(ArgumentError, "Locale is not supported")
    end

    it "loads timezone file if locale is supported" do
      expect{Cldr::Timezones.send(:load_timezones_translations, "es")}.to_not raise_error
    end
  end

  describe ".seconds_to_utc_offset" do
    it "returns a positive offset" do
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
