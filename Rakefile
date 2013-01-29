require "bundler/gem_tasks"
require "bump/tasks"
require "cldr/export"
require "cldr/download"

task :default do
  sh "rspec spec/"
end

task :export_locale do
  Cldr.download

  locale = Dir["./vendor/cldr/common/main/*.xml"].map { |path| path =~ /([\w_-]+)\.xml/ && $1 }
  options = {:locales => locale, :components => ["timezones"], :target => "cache/"}
  $stdout.sync
  Cldr::Export.export(options) { putc '.' }
  puts
end