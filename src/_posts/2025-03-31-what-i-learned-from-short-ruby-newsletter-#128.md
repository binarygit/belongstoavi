---
layout: post
title: What I Learned from Short Ruby Newsletter (#128)
categories: updates
---

I subscribed to the [Short Ruby
Newsletter](https://newsletter.shortruby.com/) a long time ago. I love
it because it contains tons of interesting examples of Ruby and Ruby on
Rails code that I would want to use in my apps. In every edition, I read
about so many things which are new to me and might be useful.

Sadly, I always read the newsletter but never remember or use the cool
new things. However, I decided to make a change, I took notes of the
things that I found interesting and were new to me and thought I would
write a small summary.

Here's what I learned in
[#128](https://newsletter.shortruby.com/p/edition-128):

## Pattern Matching

You can pattern match time in ruby:

```ruby
require 'time'

time = Time.now

case time
in { month: 1, day: 1|2 }
puts "This year is going to be great 🌟"
in { month: (1..3) }
puts "I should take it a little slow though, not tire myself 🤔"
in { month: (4..6) }
puts "What?? it's April already! 🥵"
in { month: (7..11) }
puts "No, I had no resolutions this year 🙂‍↔️"
in { month: 12, day: (20...31) }
puts "Next year is going to be great 🌟"
end
```

The above is possible because Time implements the [`deconstruct_keys`
method](https://docs.ruby-lang.org/en/master/Time.html#method-i-deconstruct_keys)

You can implement the same technique to pattern match other objects.

You can use pattern matching to bind variables from Arrays and Hashes:
```ruby
case [1,2]
in Integer => a, Integer
  puts a #-> 1
end

case [1,2]
in a, Integer
  puts a #-> 1
end

case {a: 1, b: 2}
in a:, b:
  puts a #-> 1
  puts b #-> 2
end

case {a: 1, b: 2}
in a:, b: String
  # Raises NoMatchingPatternError
end
```

Use the  `^` [pin
operator](https://docs.ruby-lang.org/en/master/syntax/pattern_matching_rdoc.html#label-Variable+pinning)
to prevent variable overriding:
```ruby
expectation = 18
case [1, 2]
in ^expectation, *rest
  "matched. expectation was: #{expectation}"
else
  "not matched. expectation was: #{expectation}"
end
```

There is also a standalone
[expression](https://docs.ruby-lang.org/en/master/syntax/pattern_matching_rdoc.html#label-Pattern+matching) version of pattern matching:

```ruby
slug = { slug: "admin" }

if slug in { slug: String => role }
  puts role #=> admin
end
```

## Message Verifier

Use
[ActiveSupport::MessageVerifier](https://api.rubyonrails.org/classes/ActiveSupport/MessageVerifier.html)
to  

- generate secure tokens for urls: password reset links, email
confirmation links

```ruby
Rails.application.message_verifier(:password_reset).generate([@user.id, 5.minutes.from_now])

id, time = Rails.application.message_verifier(:password_reset).verify(cookies[:password_reset])
if time.future?
  self.current_user = User.find(id)
end
```

This is not an encrypted string though. If you need encryption use:
[Message Encryptor](https://api.rubyonrails.org/classes/ActiveSupport/MessageEncryptor.html)

## Select Aliases
You can specify column aliases using the
[Select](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html#method-i-select) query method.

```ruby
users = User.select(email: :login_email)
users.first.login_email
```

## VNC sessions

A VNC session is used to remotely control the GUI of another computer.
[wiki](https://en.wikipedia.org/wiki/VNC)

You can use a VNC session to play games in another computer!

<hr>

I'm hugely grateful to the Short Ruby Newsletter team for curating these
insights. My biggest lesson is learning pattern matching and I can't
wait to triage my codebase to look for places I can use it!
