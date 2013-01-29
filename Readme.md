Translate the timezone names according to cldr

Install
=======

    gem install ruby-cldr-timezones

Usage
=====
    require 'cldr/timezones'

To get a basic subset of translations you can simply pass the locale.

```Cldr::Timezones``` will return a hash with the following format
```{timezone_identifier => "(GMT Offset) timezone_name_translated"}```

    Cldr::Timezones.list(:es) # {"Europe/Moscow" => "(GMT+04:00) Moscú"}
    Cldr::Timezones.list(:ja) #	{"America/Cordoba" => "（GMT-09:00）モスクワ"}

If you want to retrieve the full set of timezones (currently 581) you can simply pass the option ```:full```

    Cldr::Timezones.list(:ja, :full) #To get the full list of timezones


TODO
====
- Fallback
- Handle BIDI timezones

    ```Cldr::Timezones.list(:ar) # {"America/Cordoba" => "0}جرينتش} كوردوبا"}```
- Handle method raw which will return translated name, offset and GMT translation and format

    ```Cldr::Timezones.raw(:ja)  # {"America/Cordoba" => ["コルドバ", "+08:00", "GMT"]}```

Author
======
[Ana Martinez](https://github.com/anamartinez)<br/>
acemacu@gmail.com<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/anamartinez/ruby-cldr-timezones.png)](https://travis-ci.org/anamartinez/ruby-cldr-timezones)
