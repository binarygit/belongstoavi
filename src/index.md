---
# If you have a lot of posts, you may want to consider adding [pagination](https://www.bridgetownrb.com/docs/content/pagination)!

layout: page
title: Time in Rails
---

{% for post in collections.posts.resources %}
  {% render "post_card", title: post.data.title, url: post.relative_url, date: post.date, subtitle: post.subtitle %}
{% endfor %}
