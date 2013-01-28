$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "cldr_timezones"
require "#{name}/version"

Gem::Specification.new name, CldrTimezones::VERSION do |s|
  s.summary = "Cached cldr timezones"
  s.authors = ["Ana Martinez"]
  s.email = "acemacu@gmail.com"
  s.homepage = "http://github.com/acemacu/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end
