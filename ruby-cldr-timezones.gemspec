$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "ruby-cldr-timezones"
require "cldr/timezones/version"

Gem::Specification.new name, Cldr::Timezones::VERSION do |s|
  s.summary = "Cached cldr timezones"
  s.authors = ["Ana Martinez"]
  s.email = "acemacu@gmail.com"
  s.homepage = "https://github.com/anamartinez/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
  s.add_runtime_dependency "tzinfo"
end
