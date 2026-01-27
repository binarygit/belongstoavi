---
layout: post
title: Stop ssh from asking password
categories: updates
---

Inside `~/.ssh/config` you can create a configuration which simplifies logging in into a server:

```
Host movies
    HostName movies
    User kabir
    RequestTTY yes
    RemoteCommand tmux attach || tmux new
```

I login into a tmux session usually so the last two lines are for that. Now you can ssh using just `ssh movies`

However, it kept prompting me for a password all the time. You can stop it from asking you for a password all the time by copying over your public key to the server. To do this run the command:

```
ssh-copy-id < Hostname >
```
