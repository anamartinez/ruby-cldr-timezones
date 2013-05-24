require "cldr/timezones/version"
require "cldr/timezones/vars"
require "yaml"
require "tzinfo"

module Cldr
  module Timezones
    class << self
      #Returns a hash with the translated timezones for the locale specified.
      def list(locale, all = false)
        raise ArgumentError, "Locale cannot be blank" unless locale
        build_list(locale.to_s, all)
      end

      def raw(locale, all = false)
        raise ArgumentError, "Locale cannot be blank" unless locale
        build_raw_list(locale.to_s, all)
      end

      #Returns an array with the supported locales.
      def supported_locales
        Dir[path_to_cached_locales].map { |path| path =~ /([\w-]+)\/timezones\.yml/ && $1 }
      end

      private

      def build_list(locale, all)
        timezones_hash(locale, all) do |identifier, name, offset, system|
          [ identifier, format_timezone(offset, name) ]
        end
      end

      def build_raw_list(locale, all)
        timezones_hash(locale, all) do |identifier, name, offset, system|
          [ identifier, [ name, offset, system ] ]
        end
      end

      def timezones_hash(locale, all)
        timezones_translations = load_timezones_translations(locale)
        fallback = fallback(locale)
        timezones_identifiers = (all ? TZInfo::Timezone.all : SUBSET_TIMEZONES)

        timezone_list = timezones_identifiers.map do |timezone|
          timezone = TZInfo::Timezone.get(timezone) unless all
          name, offset, system = build_timezone(timezones_translations, fallback, timezone)
          yield timezone.identifier, name, offset, system
        end
        Hash[timezone_list]
      end

      def fallback(locale)
        return unless locale.include? "-"
        locale_tags = locale.split("-")
        fallback_locale = locale_tags[0]
        fallback_locale << "-#{locale_tags[1]}" if locale_tags.size == 3
        begin
            load_timezones_translations(fallback_locale)
        rescue ArgumentError
          return nil
        end
      end

      def load_timezones_translations(locale)
        raise ArgumentError, "Locale cannot be blank" unless locale
        raise ArgumentError, "Locale is not supported" unless File.directory?(path_to_cache(locale))
        timezones_file = File.open(path_to_cache(locale) << "/timezones.yml")
        timezones_hash = YAML.load(timezones_file)
        timezones_hash[locale]["timezones"]
      end

      def path_to_cache(locale)
        File.expand_path("../../cache/#{locale}", File.dirname(__FILE__))
      end

      def build_timezone(timezones_translations, fallback, timezone)
        name   = timezone.friendly_identifier(:friendly_identifier)
        offset = formatted_offset(timezone)

        if translation = timezones_translations[timezone.identifier]
          name = translation["city"]
        elsif fallback && (translation = fallback[timezone.identifier])
          name = translation["city"]
        end

        [name, offset, 'GMT']
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

      def path_to_cached_locales
        path = File.expand_path("../../cache/en/timezones.yml", File.dirname(__FILE__))
        path.gsub("en/timezones.yml", "*/timezones.yml")
      end
    end
  end
end
