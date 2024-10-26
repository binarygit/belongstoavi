---
layout: post
title:  Time and Rails
subtitle: It is already tomorrow in Australia.
date:   2024-10-26 18:34:09 +0545
categories: updates
---

> “Don’t worry about the world coming to an end today. It is already tomorrow in Australia.” -Charles M. Schulz

If we as website developers had any substantial power, we would've blown up the world a long long time ago.
Thank God we only hold absolute power over our apps and so are limited to destroying that. 
The earth turns indifferent to our freshly minted 500 errors.

<span class="highlight-red">But what say you?</span>
I'm better than you?
Well that maybe, but let me tell you a little about Time then, and how time is valuable to a website dev.

Especially time in Rails. Time is tricky because sometimes you want to use `Time.now`, other times it's `Time.current`
and at times you even see `Time.new`.

Let's get that out of the way.

## What is the difference between Time.(new, now, and current)?
`Time.new` let's you create a new time object. You'll need to pass in a bunch of parameters 
and keep track of which param maps to what. Was the first param a year? or was it the second one? Yuck!

Don't worry I'll show you an easier way to create one at the end of the article.

Time.now returns the system time and Time.current doesn't. Did I lose you there smarty pants?
Well let the stupid trouser guy explain it to you.
System time is the time kept by your physical computer. Let's say you open up the rails console in your
home computer in Kathmandu and type in `Time.now`. You'll get the current time in Kathmandu.
Now ssh to a server in America and type in `Time.now`, it'll give you the current time there.
Both of these are `Time` objects

Time.current returns a `ActiveSupport::TimeZone` object, and the time it's returns is TimeZone aware i.e it returns the current time
specific to a timezone. Which timezone, you ask?
Well the timezone that you've set your application to via `Time.zone=`.

```ruby
Time.zone
=> 
#<ActiveSupport::TimeZone:0x00007f08c34a72e8
 @name="Kathmandu",
 @tzinfo=#<TZInfo::DataTimezone: Asia/Kathmandu>,
 @utc_offset=nil>

Time.current
=> Sat, 26 Oct 2024 18:14:08.296070265 +0545 +05:45
```

To change it:

```ruby
Time.zone = "Darwin"
=> 
#<ActiveSupport::TimeZone:0x00007f08c34a72e8
 @name="Kathmandu",
 @tzinfo=#<TZInfo::DataTimezone: Asia/Kathmandu>,
 @utc_offset=nil>

Time.current
=> Sat, 26 Oct 2024 21:58:58.035129061 ACST +09:30
```

Above you can see that the current time has changed. So to get the current application time we need to use
Time.current.

If you just want the date, you use `Date.current`

If you want to know yesterday's date, or tomorrow's use: `Time.current.yesterday; Time.current.tomorrow`
You can even check whether today is a weekday or a weekend: `Time.current.on_weekday?; Time.current.on_weekend?`

The above methods are also available on Time objects. However if you're wondering are there any other helpul method's like the above
for `` objects, then you're in the right place. I picked out a few that I found interesting and useful and in the process I also discovered an easier
way to construct Time objects without melting my brain. Enjoy!


I could never understand the difference between Ruby Time and Rails Time until I decided to sit down and read
this great [article](https://danilenko.org/2012/7/6/rails_timezones/). It's very understandable and simple.
Go check it out.

## Get timezone of a country
`ActiveSupport::TimeZone.country_zones(<country_code>)`

```ruby
ActiveSupport::TimeZone.country_zones('np')
=> 
[#<ActiveSupport::TimeZone:0x00007f08c34a72e8
  @name="Kathmandu",
  @tzinfo=#<TZInfo::DataTimezone: Asia/Kathmandu>,
  @utc_offset=nil>]

ActiveSupport::TimeZone.country_zones('in')
=> 
[#<ActiveSupport::TimeZone:0x00007fef14897578
  @name="Chennai",
  @tzinfo=#<TZInfo::DataTimezone: Asia/Kolkata>,
  @utc_offset=nil>,
 #<ActiveSupport::TimeZone:0x00007fef14896308
  @name="Kolkata",
  @tzinfo=#<TZInfo::DataTimezone: Asia/Kolkata>,
  @utc_offset=nil>,
 #<ActiveSupport::TimeZone:0x00007fef14896290
  @name="Mumbai",
  @tzinfo=#<TZInfo::DataTimezone: Asia/Kolkata>,
  @utc_offset=nil>,
 #<ActiveSupport::TimeZone:0x00007fef14896218
  @name="New Delhi",
  @tzinfo=#<TZInfo::DataTimezone: Asia/Kolkata>,
  @utc_offset=nil>]

# To set app's timezone to mumbai
Time.zone = "Mumbai"
```

## Get US timezones
`ActiveSupport::TimeZone.us_zones`

```ruby
ActiveSupport::TimeZone.us_zones
=>                                           
[#<ActiveSupport::TimeZone:0x00007f08c3e44d00
  @name="America/Adak",
  @tzinfo=#<TZInfo::DataTimezone: America/Adak>,
  @utc_offset=nil>,
 #<ActiveSupport::TimeZone:0x00007f08c3e449b8
   @name="Hawaii",
   @tzinfo=#<TZInfo::DataTimezone: Pacific/Honolulu>, 
   @utc_offset=nil>
   ...
   ...
 ]
```

# Convert time to another zone
```ruby
`Time.current.in_time_zone("Sydney")`
=> Sat, 26 Oct 2024 15:35:41.661123338 +0545 +05:45
```

## View the offset
`Time.zone.formatted_offset`

```ruby
Time.zone.formatted_offset
=> "+05:45"

# remove colon 
Time.zone.formatted_offset(false)
=> "+0545"
```

# Creating Time/TimeWithZone objects
There is a hard way and an easy way to do things. I know I'm not a masochist because I had been creating Time objects
for a long long time and found no pleasure in it until I found the easy way and ditched suffering completely.

The hard way:
```ruby
Time.new(1999, 02, 6)
=> Sat, 06 Feb 1999 00:00:00 +0545

Time.zone.local(1999, 02, 6)
=> Sat, 06 Feb 1999 00:00:00.000000000 +0545 +05:45
```

The easy way:
```ruby
Time.parse("Feb 6 1999, 2:30am")
=> 1999-02-06 02:30:00 +0545

Time.zone.parse("Feb 6 1999, 2:30am")
=> Sat, 06 Feb 1999 02:30:00.000000000 +0545 +05:45
```

If you want to know more about Time in Rails in detail. Check out [this article](https://danilenko.org/2012/7/6/rails_timezones/). It's does a great job explaining all this stuff.
