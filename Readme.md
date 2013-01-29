Cached cldr timezones

Install
=======

    gem install ruby-cldr-timezones

Usage
=====

    Cldr::Timezones.list(:es) # {"Europe/Moscow" => "(GMT+04:00) Moscú"}
    Cldr::Timezones.list(:ja) #	{"America/Cordoba" => "（GMT-09:00）モスクワ"]
    Cldr::Timezones.list(:ja, :full) #To get the full list of timezones

    TODO
    Cldr::Timezones.list(:ar) # {"America/Cordoba" => "0}جرينتش} كوردوبا"}
    Cldr::Timezones.raw(:ja)  # {"America/Cordoba" => ["コルドバ", "+08:00", "GMT"]}

Author
======
[Ana Martinez](https://github.com/anamartinez)<br/>
acemacu@gmail.com<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/anamartinez/ruby-cldr-timezones.png)](https://travis-ci.org/anamartinez/ruby-cldr-timezones)
