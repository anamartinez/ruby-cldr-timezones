require "cldr/timezones/version"
require "yaml"
require "tzinfo"

module Cldr
  module Timezones
    class << self
      UTC_OFFSET_WITH_COLON = '%s%02d:%02d'
      UTC_OFFSET_WITHOUT_COLON = UTC_OFFSET_WITH_COLON.sub(':', '')

      #TODO Get full or important list
      def list(locale)
        raise ArgumentError, "Locale cannot be blank" unless locale

        timezones = load_timezones(locale)
        build_list(timezones, locale)
      end

      def load_timezones(locale)
        raise ArgumentError, "Locale is not supported" unless File.directory?("cache/#{locale}")
        timezones_file = File.open(File.expand_path("cache/#{locale}/timezones.yml"))
        YAML.load(timezones_file)
      end

      def build_list(timezones, locale)
        timezone_list = {}
        TZInfo::Timezone.all.each do |timezone|
          name   = timezone.identifier
          offset = formatted_offset(name)

          if translation = timezones[locale]["timezones"][name]
            name = translation["city"]
          end

          timezone_list[timezone.identifier] = format_timezone(offset, name)
        end
        timezone_list
      end

      #TODO - Get i18n format
      #Based on ActiveSupport::TimeZone
      def format_timezone(offset, name)
        "(GMT#{offset}) #{name}"
      end

      def formatted_offset(timezone_identifier)
        offset_in_seconds = utc_total_offset(timezone_identifier)
        seconds_to_utc_offset(offset_in_seconds)
      end

      def utc_total_offset(timezone_identifier)
        (TZInfo::Timezone.get(timezone_identifier).current_period.offset.utc_total_offset).to_f
      end

      def seconds_to_utc_offset(seconds, colon = true)
        format = colon ? UTC_OFFSET_WITH_COLON : UTC_OFFSET_WITHOUT_COLON
        sign = (seconds < 0 ? '-' : '+')
        hours = seconds.abs / 3600
        minutes = (seconds.abs % 3600) / 60
        format % [sign, hours, minutes]
      end
    end
  end
end
