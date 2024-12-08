---
layout: post
title: How to write good background jobs in Ruby on Rails
categories: updates
---

Writing background jobs is a common task for any Ruby on Rails developer.
I searched around for a post about best practices and couldn't find one,
so I decided to write one.

These are simple ideas that I stick to when writing jobs, some I got
from asking around at the [RoR slack](https://www.rubyonrails.link/), others were recommended by my tech
lead during code review. I hope you find these useful.

## Job should be small and do only one thing

```ruby

class HutpotCreateTicketJob < ApplicationJob
  queue_as :default

  def perform(user_id:, hotel_id:, subject:, content:)
    user = User.find(user_id)
    hotel = Hotel.find(hotel_id)

    Hutpot::CreateTicket.run!(
      user: user,
      hotel_id: hotel.id,
      subject: subject,
      content: content
    )
  end
end

```

It's that simple. If this job fails you can simply ask it to
retry and if it's idempotent, you'll have no problems.

## Job should be idempotent

```ruby

class HutpotCreateTicketJob < ApplicationJob
  queue_as :default

  def perform(user_id:, hotel_id:, subject:, content:)
    user = User.find(user_id)
    hotel = Hotel.find(hotel_id)

    Hutpot::CreateTicket.update!(
      user: user,
      hotel_id: hotel.id,
      subject: subject,
      content: content
    )
  end
end
```

> Idempotent(adj.) => "An idempotent function has an effect the first
> time it runs successfully and has no further effects on
> re-execution."

`update!` wraps its query inside a transaction. This means if something
goes wrong the update is rolled back. 

This job is idempotent because on re-runs, after a successful run, it'll
not have any effect on the system.

## Job should log various information

```ruby
# frozen_string_literal: true

# Sets student benefit to active at the specified time.
class SetStudentBenefitToActiveJob < ApplicationJob
  queue_as :default

  def perform(student_benefit)
    return if student_benefit.active?

    unless student_benefit.enable_at.between?(Time.current.beginning_of_day, 
                                                 Time.current.end_of_day)
      return logger.info("#{self.class} exited because StudentBenefit##{student_benefit.id} /
      enable_at has been changed to #{student_benefit.enable_at} from #{Time.current}")
    end

    student_benefit.update!(active: true, auto_enabled_at: Time.current, enable_at: nil)
  end
end
```

I like to log various information from inside the job in case something
goes wrong and I have to debug.

Also note the `auto_enabled_at` column in `student_benefit` and the job
updating it. This is also in case I need to debug something.

## Two patterns for scheduling jobs

### Job is scheduled via a parent scheduler

```ruby
# frozen_string_literal: true

# Schedules jobs that set student benefits to active at the specifed time.
class ScheduleStudentBenefitToActiveJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    student_benefits = StudentBenefit.where(enable_at: Time.current.all_day, active: false)
    student_benefits.each { SetStudentBenefitToActiveJob.set(wait_until: _1.enable_at).perform_later(_1) }

    logger.info "#{self.class} processed #{student_benefits.size} seasons with ids: #{student_benefits.pluck :id}"
  end
end

# Sets student benefit to active at the specified time.
class SetStudentBenefitToActiveJob < ApplicationJob
  queue_as :default

  def perform(student_benefit)
    return if student_benefit.active?

    unless student_benefit.enable_at.between?(Time.current.beginning_of_day, 
                                                 Time.current.end_of_day)
      return logger.info("#{self.class} exited because StudentBenefit##{student_benefit.id} /
      enable_at has been changed to #{student_benefit.enable_at} from #{Time.current}")
    end

    student_benefit.update!(active: true, auto_enabled_at: Time.current, enable_at: nil)
  end
end
```

```yaml
# recurring.yml

activate_student_benefits:
  class: ScheduleStudentBenefitToActiveJob
  schedule: every day at 12am
```

In this pattern, a parent job (`Schedule...`) is run everyday via a
cronjob. This job in turn schedules a `Set...` job.

Notice that both jobs are small and do only one thing.

### Job is scheduled via a callback

```ruby
# student_benefit.rb

after_commit :schedule_student_benefit_to_active, on: %i[create update]

def schedule_student_benefit_to_active
  return unless enabled_at.changed?
  
  SetStudentBenefitToActiveJob.set(wait_until: self.enable_at).perform_later(self)
end
```

In this pattern, someone creates or updates a `student_benefit` object.
If that happens we enqueue a `SetStudentBenefitToActiveJob` to run at
the `enable_at` time.

There are some differences between the two patterns. I prefer the second
pattern because it means I don't have to keep adding cron jobs for each
new job I write.

<hr>

These are just things I keep in mind when writing my jobs and till now they have served me well.
I also came across this
[article](https://github.com/sidekiq/sidekiq/wiki/Best-Practices) in the
sidekiq wiki, and was delightfully surprised to find that my points and
the points listed there are very similar. If Sidekiq also recommends the
same thing, I must be doing something right!

Hope you enjoyed this. Email me if you have any best practices you
follow. I would love to know what you're doing!
