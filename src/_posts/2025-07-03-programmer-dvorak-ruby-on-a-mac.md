---
layout: post
title: Programmer dvorak (ruby) on a mac
categories: updates
---

I use a modified version of programmer dvorak to type because when I learnt to program and used QWERTY to type my wrists started to hurt. I recently bought a mac and here's how I ported it over to the mac.

I learnt to create custom layouts for linux using this [guide](https://askubuntu.com/a/511142) but had no clue how to create one for macos. I thought it would be as easy as copy pasting my keyboard definition from linux to some folder in macos but I quickly found out that wasn't the case.

In my search for finding tools for custom keyboard definitions in macos I came across two tools: [Karabiner](https://karabiner-elements.pqrs.org/) nad [Ukelele](https://software.sil.org/ukelele/).

I setup the original programmer dvorak in my machine using these [instructions](https://www.kaufmann.no/roland/dvorak/macosx.html) and then tried to modify the layout in Ukelele. Ukelele gave me an error that it couldn't read the `.keylayout` file included with this, so I found this version of programmer dvorak `keylayout` file which works with ukelele. Here's the [link](https://github.com/jayliu50/macos-programmer-dvorak)

I loaded this file in ukelele and then modified it according to my needs. I couldn't use the keyboard by just copying over the `.bundle` folder to the `/Library/ ...` folder and had to use the ukelele installer to get it working.

I use [karabiner](https://karabiner-elements.pqrs.org/) to swap my Capslock and ESC keys and tried using Karabiner to modify the installed version of programmer dvorak but specifying rules for each key turned out to be quite tedious which is why I abandoned it.

Here's what my version of programmer dvorak looks like:
<img style="float: right" src="/images/programmer-dvorak-ruby.png" alt="">

The swapping of `; -> :` and `@ -> &` is why I call this layout `dvorak-ruby`. In ruby, you use colon and @ more and so I placed it in places where it's easier to type from (atleast for me).

In addition to these changes, I revert the changes to the number row which programmer dvorak makes. I just can't use a number row that's so jumbled up!
