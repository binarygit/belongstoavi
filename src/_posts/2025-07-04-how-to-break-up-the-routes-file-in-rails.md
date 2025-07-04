---
layout: post
title: How to break up the routes file in rails
categories: updates
image_name: two-roads.webp
description: How to use multiple routes file in Ruby on Rails
---

The routes file can grow large very quickly. Rails provides the `draw(name)` method to load another routes file into the main `config/routes.rb` so that the routes are easily discoverable and readable.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  draw :admin                 # Loads `config/routes/admin.rb`
end

# config/routes/admin.rb
namespace :admin do
  resources :accounts
end
```

You can read more about this here: https://guides.rubyonrails.org/routing.html#breaking-up-a-large-route-file-with-draw
