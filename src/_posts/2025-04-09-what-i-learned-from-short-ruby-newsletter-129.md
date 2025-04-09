---
layout: post
title: What I Learned from Short Ruby Newsletter (#129)
image_name: mononoke-final.png
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
[#129](https://newsletter.shortruby.com/p/edition-129):


## Hotwire cheatsheet

Igor Kasyanchuk published a [hotwire cheatsheet](https://cheatsheetshero.com/user/igor-kasyanchuk/930-hotwire-for-ruby-on-rails-developers-cheatsheet?utm_source=shortruby&ref=shortruby.com#page-3607) which will come in handy everytime I want to glance and quickly find something out about hotwire.

## Custom Rails Constraints

[This](https://pankowecki.pl/posts/slack-routing/) great article talks about using contraints to route webhooks sent from slack to proper controller actions. Using this approach you don't have to conditionally check _in the controller_ what type of webhook event you've got and then route it to the proper action.

```ruby
Rails.application.routes.draw do
  post '/slack/events', 
    to: 'slack/messages#received',
    constraints: EventsConstraint['message']
  
  post '/slack/events',
    to: 'slack/messages#mentioned',
    constraints: EventsConstraint['app_mention']
  
  post '/slack/events',
    to: 'slack/home#opened',
    constraints: EventsConstraint['app_home_opened']
  
  post '/slack/events', 
    to: 'slack#events' # catch-all for remaining events
end
```

Above he draws the same route four times `/slack/events` but according to what event_type the webhook contains, the request is routed to the proper controller.

For constraints to work, all you need is a `matches?` method that returns true or false. [docs](https://guides.rubyonrails.org/routing.html#advanced-constraints)

*Did you know that rails provides subdomain constraints by default?*

```ruby
get "photos", to: "photos#index", constraints: { subdomain: "admin" }

# The above will route admin.example.com/photos to Photos#index
```

[I didn't!](https://guides.rubyonrails.org/routing.html#request-based-constraints)

## ActionMailer::Base#email_address_with_name

There's an [email_address_with_name](https://api.rubyonrails.org/classes/ActionMailer/Base.html#method-c-email_address_with_name) helper which returns an email address in the format of `<Some Name> <email address>`

We were using these kind of addresses in many parts of the codebase I work on and so I was able to refactor that into using this method.

## Use bundler inline for quick scripts

I have seen this used in many bug recreation scripts in the Rails repo but never realized it was this simple.

```ruby
require 'bundler/inline'

gemfile do
  source "https://rubygems.org/"
  gem "paint"
end

puts Paint['Ruby', :red] 
#=> prints Ruby in red color
```

## Multiple Gemfiles

I hadn't realized that I could use multiple Gemfiles in the same repo. This seems useful.

```ruby
# Gemfile

gem ...
gem ...

if File.exist?('Gemfile.local')
  puts "\n>> Installing local development specified gems..."
  system("bundle check --gemfile=Gemfile.local || bundle install --jobs=4 --gemfile=Gemfile.local")
end

# Gemfile.local

source "https://rubygems.org"

gem "paint"
```

This will create a new `Gemfile.local.lock` file that tracks the gem versions installed via the `Gemfile.local` file.

<hr>

I'm hugely grateful to the Short Ruby Newsletter team for curating these
incredibly useful tips and tricks. My biggest lesson is learning about using Custom Routing Constraints 
and I can't wait to triage my codebase to look for places I can use it!
