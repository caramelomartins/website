---
title: Managing Atom's Installed Packages with Ruby
date: "2017-02-22T19:48:00"
category:
  - atom
  - ruby
---

I use the Atom editor a lot. In fact, be in Windows or Linux, it's my standard text editor.

I love it's flexibility and the fact that it's completely hackable. I can do whatever I want with it. It supports a whole range of programming languages. It has great support from community.

With that being said, managing a Windows configuration and a Linux configuration, in separate devices, can be very confusing.

Last week, I had my first experience of messing up my configuration because of that. I started messing around with Atom's `packages` folder and, soon enough, I had deleted it. Given that I had another configuration, I was able to salvage what I had just deleted - not without some panic involved.

I decided that I would no longer suffer such panic again, so I wrote a nifty little Ruby script to help me.

The script is very basic. Clocking at 39 LOC - with 10 being comments.

What the script does is very simple:

- Fetch all packages in Atom, in JSON format, with `apm list -j`.
- Iterate over those packages and filter only the user installed packages.
- For each of the user installed packages, fetch its name, version, homepage and repository details.
- Save that information into an array.
- Write it to a file, in a predefined location.

As you can see by the easiness of the description, the script is basic. Although it is a basic script, it allowed me to get a taste for the Ruby language, which I have been yearning to learn for some months.

I must say that I'm amazed both at its power and syntax. I'll be sure to keep working through it to see if I can hack it.

The code to the script is [open sourced](https://github.com/caramelomartins/dotfiles/blob/master/script/refresh_ap.rb) on my [dotfiles](https://github.com/caramelomartins/dotfiles) repository.
