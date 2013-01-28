Cached cldr timezones

Install
=======

    gem install ruby-cldr-timezones

Usage
=====

    Cldr::Timezones.list(:en) # {"America/Cordoba" => "America/Cordoba (GMT-09:00)"}
    Cldr::Timezones.list(:ja) #	{"America/Cordoba" => "コルドバ （GMT-09:00）"]
    Cldr::Timezones.list(:ar) # {"America/Cordoba" => "0}جرينتش} كوردوبا"}

    TODO
    Cldr::Timezones.raw(:ja) # {"America/Cordoba" => ["コルドバ", "+08:00", "GMT"]}

Author
======
[Ana Martinez](https://github.com/acemacu)<br/>
acemacu@gmail.com<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/acemacu/ruby-cldr-timezones.png)](https://travis-ci.org/acemacu/ruby-cldr-timezones)
