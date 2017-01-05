---
title: wifi-password in Perl
date: "2016-08-03T00:00:00"
category:
  - projects
tags:
  - perl
---

**tl;dr**

I wrote a new little script that shows you the password of the wifi you are currently on using Perl. It can be found [here](https://github.com/caramelomartins/wifi-password.pl).

```perl
$ wifi-password.pl -h

Usage wifi-password [OPTIONS] [SSID]

Options:
 -v, --version    Output version.
 -h, --help    This message.
```

# Some Background

Last week I had some time off, in between jobs, and I chose to use one of those afternoons to implement a new script in of the new languages I'm expected to use in my new job.

Based on that, the options were:

- PHP
- Perl
- ColdFusion Markup Language

ColdFusion would require me to run a server, I checked and the only good open source resource I was able to find was [Railo](http://www.getrailo.org/) which unfortunately has been down for quite awhile - off it goes.

PHP would have been a great choice but I have some light experience with PHP and an afternoon's work wouldn't help much more in the light knowledge I already have - off it goes.

In comes Perl, which I had no knowledge off and actually wanted to try.

# Where the Idea Came From

During that same time period, while I was browsing across Hacker News, I came across this great little project written in Shell - [wifi-password](https://github.com/rauchg/wifi-password).

I found the script so simple and elegant that I wished I had thought about it and written it first. So I just decided to write one with Perl.

Even though it's only supported in Ubuntu environments (at least that's the only environment I have tested it with) I found it extremely interesting to write and learn the simple basics of Perl syntax which was my main goal.

# The Actual Code

At the beginning we start by using `strict` and `warnings` along with a shebang:

```perl
#!/usr/bin/env perl

use strict;
use warnings;
```

We use `use strict;` because basically it prevents a shitload of, as per the [documentantion](http://perldoc.perl.org/strict.html), _"expressions that could behave unexpectedly or are difficult to debug, turning them into errors"_.

`use warnings;` is used to enabled the compiler warnings when interpreting the code.

> NOTE: `warnings` should only be used for non-production running scripts. It'll trigger warnings while the code is running so it will be annoying for end users if it is used.

After that, we set some global variables using the `my` keyword:

```perl
my $version        = "0.0.2";
my $networkManager = "/etc/NetworkManager/";
my $ssid           = "";
my $pwd            = "";
```

I used `my` because I didn't intend to write a Perl module neither did I intended for the variables to be used elsewhere other than this file. According to the [documentation](http://perldoc.perl.org/functions/my.html) the `my` keyword restricts the scope of a variable to _"A my declares the listed variables to be local (lexically) to the enclosing block, file, or eval."_.

Then I went to define a simple subroutine that I could call whenever users needed some help:

```perl
# Help message subroutine.
sub help() {
    print("\nUsage wifi-password [OPTIONS] [SSID]\n");
    print("\nOptions:\n");
    print(" -v, --version\tOutput version.\n");
    print(" -h, --help\tThis message.\n");
    print("\n");
}
```

Another subroutine to check for installed dependencies - because the script has 5 dependencies with few lines of code:

```perl
# Check dependencies.
sub checkDependencies() {
    if    ( `which perl` eq "" )  { die "ERROR: perl not installed.\n\n" }
    elsif ( `which nmcli` eq "" ) { die "ERROR: nmcli not installed.\n\n" }
    elsif ( `which cat` eq "" )   { die "ERROR: cat not installed.\n\n" }
    elsif ( `which grep` eq "" )  { die "ERROR: grep not intsalled.\n\n" }
    elsif ( `which sed` eq "" )   { die "ERROR: sed not installed.\n\n" }
}
```

Then we validate for arguments. Only 2 arguments are evaluated at a time even though there is no limit of arguments to be passed.

Apart from that, to make it faster to develop, it is only possible to pass either a flag or the optional SSID - if both are passed the flag is parsed but the SSID is not:

```perl
if ( $#ARGV > 0 ) {
    help();
    exit 1;
}
elsif ( $#ARGV > -1 ) {
    if    ( $ARGV[0] eq "-v" ) { print "$version\n"; exit 1; }
    elsif ( $ARGV[0] eq "-h" ) { help();             exit 1; }
    else                       { $ssid = $ARGV[0] }
}
```

After that we just call `checkDependencies()` and we are done with validation.

Next, we check if an SSID was passed. If it wasn't we just go ahead and check the SSID to which we are connected at the moment. We do this using `nmcli`, `grep` along `sed`, inside a one liner, to retrieve the line from the `nmcli` which has the "connected" keyword.

We parse the result through a _regex_ that will trim all whitespace that might still be in the string:

```perl
# Set SSID or use default.
if ( $ssid eq "" ) {
    $ssid =
`nmcli -t -f type,state,connection d | grep wifi | grep connected: | sed "s/^wifi:connected://"`;

# http://stackoverflow.com/questions/3931569/how-can-i-remove-all-whitespaces-and-linebreaks-in-perl
    $ssid =~ s/\s+//g;

    unless ( $ssid ne "" ) {
        die "ERROR: SSID couldn't be found. Are you connected to wifi?\n\n";
    }
}
```

I really fancy `unless` for error handling. It's a great addition to Perl.

Finally, we just verify that, in fact, there's a network connection with the defined SSID (this is especially useful if the SSID was given instead of fetched), fetch the password from the NetworkManager files and print the password along with the SSID:

```perl
# Verify that a Network connection exists.
my $path = "$networkManager" . "system-connections/$ssid";

unless ( -e $path ) {
    die "ERROR: SSID \"$ssid\" is not defined on this machine.\n\n";
}

# Read from file.
my $command = "sudo cat $path | grep psk= | sed \"s/^psk=//\"";
$pwd = `$command`;

# Print SSID & PWD.
print "SSID: $ssid\n";
print "Password: $pwd\n";
```

I found that NetworkManager stores its passwords inside files named with the SSID in `/etc/NetworkManager/system-connections/[SSID]` because of that there's a need to run this script as a super user. I found this information inside the source code for [wifi-password](https://github.com/rauchg/wifi-password).

Even though it is a very simple script it was a manageable, interesting afternoon spent slowly building the script and learning Perl's basics.
