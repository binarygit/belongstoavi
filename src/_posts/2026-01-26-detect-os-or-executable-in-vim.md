---
layout: post
title: Detect OS or executable in vim and bash
categories: updates
---

There are some mappings in my .vimrc which are conditional to the underlying OS.
To check which OS I'm running, you can use vim's `has()` function:

```vim
if has('macos')
   ...
elseif has('linux')
    ...
endif
```

If you want to check whether you have a program installed in your machine. You can use the `executable` function:

```vim
if executable('ag')
    set grepprg=ag\ --vimgrep
endif
```

## How to check what OS you're running in bash
You can use the $OSTYPE variable to check what OS you run in bash.

An example from my .bash_aliases:

```bash
# Explains why this returns "darwin24" for macos: https://apple.stackexchange.com/a/401881
if [ $OSTYPE == "darwin24" ]
then
  alias eu="ls -GF"
else
  alias eu="ls"
fi
```

To detect an executable in bash, you do:
```bash
if command -v batman &> /dev/null; then
  ...
else
  ...
fi
```
