---
layout: post
title: Override default latency in fswatch
categories: updates
---

I use `fswatch` to recompile my code via a ruby script to a index.html file and I noticed that there was almost a 1 second delay until the script was called. After benchmarking my ruby script and finding nothing wrong there I thought it was an xargs issue because I was piping `fswatch` to xargs.

At the end I found out that `fswatch` has a default latency of 1s and so here's how you can pass in a smaller latency period so that your script can run faster:

`fswatch -l 0.1 # sets a latency for 1ms`

Here's the whole command I'm using:

```bash
fswatch -or -l 0.1 app/ | xargs ruby main.rb
```
