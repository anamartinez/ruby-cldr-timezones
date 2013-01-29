require "cldr/timezones/version"
require "cldr/timezones/vars"
require "yaml"
require "tzinfo"

module Cldr
  module Timezones
    class << self
      def list(locale, all = false)
        raise ArgumentError, "Locale cannot be blank" unless locale
        build_list(locale.to_s, all)
      end

      private

      def build_list(locale, all)
        timezones_translations = load_timezones_translations(locale)
        timezone_list = {}

        if all
          timezones_identifiers = TZInfo::Timezone.all
        else
          timezones_identifiers = SUBSET_TIMEZONES
        end

        timezones_identifiers.each do |timezone|
          timezone = TZInfo::Timezone.get(timezone) unless all
          timezone_list[timezone.identifier] = build_timezone(timezones_translations, timezone)
        end
        timezone_list
      end

      def load_timezones_translations(locale)
        raise ArgumentError, "Locale is not supported" unless File.directory?("cache/#{locale}")
        timezones_file = File.open(File.expand_path("cache/#{locale}/timezones.yml"))
        timezones_hash = YAML.load(timezones_file)
        timezones_hash[locale]["timezones"]
      end

      def build_timezone(timezones_translations, timezone)
        name   = timezone.friendly_identifier(true)
        offset = formatted_offset(timezone)

        if translation = timezones_translations[timezone.identifier]
          #TODO Fallback?
          name = translation["city"]
        end

        format_timezone(offset, name)
      end

      #TODO - Get i18n format
      #Based on ActiveSupport::TimeZone
      def format_timezone(offset, name)
        "(GMT#{offset}) #{name}"
      end

      def formatted_offset(timezone)
        offset_in_seconds = utc_total_offset(timezone)
        seconds_to_utc_offset(offset_in_seconds)
      end

      def utc_total_offset(timezone)
        (timezone.current_period.offset.utc_total_offset).to_f
      end

      def seconds_to_utc_offset(seconds)
        sign = (seconds < 0 ? '-' : '+')
        hours = seconds.abs / 3600
        minutes = (seconds.abs % 3600) / 60
        UTC_OFFSET_WITH_COLON % [sign, hours, minutes]
      end
    end
  end
end
