---
layout: post
title: Maybe you are wasting your time typing so much in the rails console
categories: updates
---

Maybe you are wasting your time typing so much in the rails console by not defining custom helper methods.

Typing out `User.find_by(email: some@email.com)` starts to get tiring quickly when all you want is a random user or
you might need an admin account for some reason and now you're doing `User.admin.last`. You might have memberships 
in your app and different kinds of memberships (Silver, Gold, Platinium), and you want to get a user with a gold membership
so you type `Membership.gold.users.last`. What if you could cut away all that typing and just get a gold user by typing `$gu`?
Would you be angry at yourself because you typed less?

I keep a handful of methods and scripts in all the project I'm involved in so that it saves me time in the console.

To set this up you need a helper file which will contain all the helpers you need:

## Small scripts

```ruby
require "irb/helper_method"

class DestroyRegistrationHelper < IRB::HelperMethod::Base
  description "Destroy a registration"

  def execute(reg_id)
    Registration.destroy(reg_id)
  end
end

class LastRegistrationHelper < IRB::HelperMethod::Base
  description "Finds the last registration"

  def execute
    Registration.last
  end
end

class FindUserHelper < IRB::HelperMethod::Base
  description "Finds a user"

  def execute(user_email)
    User.find_by(email: user_email)
  end
end

class AviHelper < IRB::HelperMethod::Base
  description "Avi"

  def execute
    return $avi if $avi

    $avi = User.find_by(email: "avii@hey.com")
  end
end

IRB::HelperMethod.register(:dreg, DestroyRegistrationHelper)
IRB::HelperMethod.register(:fu, FindUserHelper)
IRB::HelperMethod.register(:avi, AviHelper)
IRB::HelperMethod.register(:lreg, LastRegistrationHelper)

```

We then need to require it in `./.irbrc`, so that the rails console picks it up:

```ruby
require_relative "path_to_helper_script"

```

and voila!

```ruby
# inside rails console

dreg 420
=> destroys Registration with id 420
```

[extending irb docs](https://ruby.github.io/irb/EXTEND_IRB_md.html)

## Bigger scripts

While the above scripts were smaller finder funtions.

These are scripts that do a little more and are very much tied to the application logic.

Example:

```ruby
# enable_membership_signup.rb

# controller logic is in registrations#can_signup_for_membership?
# there's a Membership::CanSignup interaction which houses the logic
# the url for the membership signup modal looks like: http://localhost:3000/registrations/702313/membership_signup
def enable_membership_signup(registration)
  registration.season.update!(skip_membership_signup_page: false)
  registration.season.config.update!(membership_enabled: true)
  return "User is a supervisor or staff" if user.role?(registration.league, :supervisor, :field_staff)

  UserLeagueMembership.deactivate_membership(registration.user, registration.league)
end

```

The above script enables membership in a "season", this function is very
application specific and I have other scripts too, like assigning a user
to another season, adding player credits to a player etc

You might have an application where admins can `impersonate a user`, and 
you could impersonate them through the GUI but it's faster when you do it using a script.

These can be a real time saver because you don't need to go around the GUI clicking buttons.
