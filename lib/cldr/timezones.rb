require "cldr/timezones/version"
require "cldr/timezones/vars"
require "yaml"
require "tzinfo"

module Cldr
  module Timezones
    class << self
      def list(locale, all = false)
        raise ArgumentError, "Locale cannot be blank" unless locale
        bcp_locale = locale_from_symbol(locale)
        build_list(bcp_locale, all)
      end

      private

      #To match BCP-47 format
      def locale_from_symbol(locale)
        locale = locale.to_s
        return locale.downcase unless locale.include?("_")
        locale = locale.split('_')

        locale.each_with_index do |val, index|
          if index == 0
            val.downcase!
          elsif val.size == 4
            val.capitalize!
          else
            val.upcase!
          end
        end
        locale.join("-")
      end

      def build_list(locale, all)
        timezones_translations = load_timezones_translations(locale)
        fallback = fallback(locale)
        timezones_identifiers = (all ? TZInfo::Timezone.all : SUBSET_TIMEZONES)

        timezone_list = timezones_identifiers.map do |timezone|
          timezone = TZInfo::Timezone.get(timezone) unless all
          [timezone.identifier, build_timezone(timezones_translations, fallback, timezone)]
        end
        Hash[timezone_list]
      end

      def fallback(locale)
        return unless locale.include? "-"

        locale_tags = locale.split("-")
        begin
          if locale_tags.size == 2
            load_timezones_translations(locale_tags[0])
          elsif locale_tags.size == 3
            load_timezones_translations(locale_tags[0] + "-" + locale_tags[1])
          end
        rescue ArgumentError
          return nil
        end
      end

      def load_timezones_translations(locale)
        raise ArgumentError, "Locale cannot be blank" unless locale
        raise ArgumentError, "Locale is not supported" unless File.directory?("cache/#{locale}")
        timezones_file = File.open(File.expand_path("cache/#{locale}/timezones.yml"))
        timezones_hash = YAML.load(timezones_file)
        timezones_hash[locale]["timezones"]
      end

      def build_timezone(timezones_translations, fallback, timezone)
        name   = timezone.friendly_identifier(:friendly_identifier)
        offset = formatted_offset(timezone)

        if translation = timezones_translations[timezone.identifier]
          name = translation["city"]
        elsif fallback && (translation = fallback[timezone.identifier])
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
