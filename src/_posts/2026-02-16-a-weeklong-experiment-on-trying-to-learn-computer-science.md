---
layout: post
title: A weeklong experiment on trying to learn computer science
categories: updates
---

This week I've set myself up a challenge. I want to read 4 hours of SICP - and read it however I like. Pursue the maths stuff as it comes along, learn that, spend as much time as I want on practice sets. Learn slowly - explain what I've learnt to myself and recursively improve my understanding. At the end of the week - I'll just access how I felt about this because trying to learn with a handgun pointed at my head is just not working for me. 

I'm reading SICP as part of https://teachyourselfcs.com/ curriculum.

## Monday

- I felt bored after 2 hours. It was because I was trying *not to* tackle the counting change problem. I was just reading it through, and trying to bypass it. Once I dug my heels in and started to write down and tried to understand it, it became less boring and I actually didn't realize how easily time passed.
- After I think for 30min or an hour - I start to taper off. I think it's just because I'm not used to thinking on hard problems for a long time.

### Questions I have

1. How is the counting change algorithm working?
-> I went through the algorithm and counted change for Rs. 10. Denominations are: Rs. 5, Rs. 2 and Rs. 1

`cc(10, 3) -> 9` and `cc(5, 2) -> 3` 

I can see how the recursion occurs and the shape and progress of the iterations + space taken.

What I don't have a sense of is "How is this algorithm working?" eg: If I wanted to explain this algorithm to somebody else - I could tell them how to compute this but I couldn't explain to them why the solution works.

In contrast, I can explain the steps and why the fibonacci solutions work to somebody else.

<img style="float: right" src="/images/counting-change-sicp.jpeg" alt="">

(is this problem the same as: for a number X, how many different ways can you construct X using n numbers, where n are the numbers less than X. So, X = 4, then what ways can you add up to 4 using 1, 2 and 3? -> no, stupid it's not)
