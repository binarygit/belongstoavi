---
layout: post
title: How to write good background jobs in Ruby on Rails
categories: updates
---

I have been writing a lot of background jobs recently so I decided to
write up a few "best practices" that I follow.

## Job should be small and do only one thing

```ruby

class HotpotCreateTicketJob < ApplicationJob
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

It's simple as that. If this job fails you can simply ask it to
retry and if it's idempotent, you'll have no problems.

## Job should be idempotent

```ruby

class HotpotCreateTicketJob < ApplicationJob
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

> Idempotent(adj.) => "Describing an action which, when performed multiple
times, has no further effect on its subject after the first time it is
performed."

`update!` wraps it's query inside a transaction. This means if something
goes wrong the update is rolled back. 

This job is idempotent because if it fails and we re-run it it'll not
cause any unintended changes in our system.

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

If you ever had to debug why a certain StudentBenefit that was enqueued
for activation wasn't activated, You can check the logs and would find
the reason displayed in the logs.

Also note the `auto_enabled_at` column in `student_benefit`.

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

Hope you enjoyed this. Email me if you have any best practices you
follow and think it should be included here.
