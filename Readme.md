Translated timezones according to CLDR

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

There is also support for fallback.

    Cldr::Timezones.list(:"es-MX") # {"Europe/Moscow" => "(GMT+04:00) Moscú"}

If you want to retrieve the full set of timezones (currently 581) you can simply pass the option ```:full```

    Cldr::Timezones.list(:ja, :full) #To get the full list of timezones

If you want to get a list which contains the translated name, offset and GMT translation and format for each translation (supports :full option, i.e. `:pt, :full`)

    Cldr::Timezones.raw(:ja) # {"America/Cordoba" => ["コルドバ", "+08:00", "GMT"]

If you want to get the list of supported languages

    Cldr::Timezones.supported_locales # ["aa", "aa-DJ", "aa-ER", "aa-ET",...."zh-Hant-TW", "zu", "zu-ZA"]

If your project is already using ActiveSupport mapping and you want backwards compatibility use:

    Cldr::Timezones.list(:ja, :rails_identifiers) # {"St. Petersburg" => "(GMT+04:00) Moscú"}

If you want both ActiveSupport mapping and the full list of timezones use:

    Cldr::Timezones.list(:ja, {:rails_identifiers => true, :full => true}) #To get the full list of timezones


TODO
====
- Handle BIDI timezones

    ```Cldr::Timezones.list(:ar) # {"America/Cordoba" => "0}جرينتش} كوردوبا"}```

Author
======
[Ana Martinez](https://github.com/anamartinez)<br/>
acemacu@gmail.com<br/>
License: MIT<br/>


[![Build Status](https://travis-ci.org/anamartinez/ruby-cldr-timezones.png)](https://travis-ci.org/anamartinez/ruby-cldr-timezones)
[![Code Climate](https://codeclimate.com/github/anamartinez/ruby-cldr-timezones.png)](https://codeclimate.com/github/anamartinez/ruby-cldr-timezones)
