require "cldr/timezones/version"
require "cldr/timezones/vars"
require "yaml"
require "tzinfo"

module Cldr
  module Timezones
    class << self
      #Returns a hash with the translated timezones for the locale specified.
      def list(locale, all = false, rails_identifiers = false)
        raise ArgumentError, "Locale cannot be blank" unless locale
        build_list(locale.to_s, all, rails_identifiers)
      end

      def raw(locale, all = false, rails_identifiers = false)
        raise ArgumentError, "Locale cannot be blank" unless locale
        build_raw_list(locale.to_s, all, rails_identifiers)
      end

      #Returns an array with the supported locales.
      def supported_locales
        Dir[path_to_cached_locales].map { |path| path =~ /([\w-]+)\/timezones\.yml/ && $1 }
      end

      private

      def build_list(locale, all, rails_identifiers)
        timezones_hash(locale, all, rails_identifiers) do |identifier, name, offset, system|
          [ identifier, format_timezone(offset, name) ]
        end
      end

      def build_raw_list(locale, all, rails_identifiers)
        timezones_hash(locale, all, rails_identifiers) do |identifier, name, offset, system|
          [ identifier, [ name, offset, system ] ]
        end
      end

      def timezones_hash(locale, all, rails_identifiers)
        timezones_translations = load_timezones_translations(locale)
        fallback = fallback(locale)
        timezones_identifiers = (all ? TZInfo::Timezone.all : SUBSET_TIMEZONES)
        timezone_list = []
        timezones_identifiers.each do |timezone|
          timezone = TZInfo::Timezone.get(timezone) unless all
          name, offset, system = build_timezone(timezones_translations, fallback, timezone)
          identifier_name = timezone_identifier_mapping(timezone.identifier, rails_identifiers)
          if identifier_name.is_a? Array
            identifier_name.each {|identifier| timezone_list << yield(identifier, name, offset, system)}
          else
            timezone_list << yield(identifier_name, name, offset, system)
          end
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

      def timezone_identifier_mapping(cldr_identifier, rails_identifiers)
        return cldr_identifier unless rails_identifiers
        RAILS_IDENTIFIERS[cldr_identifier] || cldr_identifier
      end
    end
  end
end
