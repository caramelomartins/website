---
title: "How to Escape { in Python"
date: 2019-11-11T10:00:00Z
draft: false
summary: "Last week, I was faced with an intriguing question. How do I escape `{` when using `str.format` in Python?"
categories:
- python
---

Last week, I was faced with an intriguing question. How do I escape `{` when using `str.format` in Python?

[str.format(](https://docs.python.org/3/library/stdtypes.html#str.format)[**args*](https://docs.python.org/3/library/stdtypes.html#str.format)[,](https://docs.python.org/3/library/stdtypes.html#str.format) [***kwargs*](https://docs.python.org/3/library/stdtypes.html#str.format)[)](https://docs.python.org/3/library/stdtypes.html#str.format) is a function that can be used to perform string formatting. Explicit, huh? A simple example of using `str.format` is:


    >>> "Hello {}!".format("World")
    'Hello World!'

But…what if you need to format a string that actually has the character `{` in it, such as a *“Hello {World}!”*? It is actually fairly simple. From \[Format String Syntax\](https://docs.python.org/3/library/string.html#formatstrings):


> Format strings contain “replacement fields” surrounded by curly braces `{}`. Anything that is not contained in braces is considered literal text, which is copied unchanged to the output. **If you need to include a brace character in the literal text, it can be escaped by doubling:** `**{{**` **and** `**}}**`**.**

So, our initial example would be:


    >>> "Hello {{{}}}!".format("World")
    'Hello {World}!'

That’s right, you need 3 braces! `{{` turns into `{` once the string is formatted, `}}` turns into `}` once the string is formatted and the middle `{}` are the braces that actually allow you to dynamically  format the string.

A few more examples:


    >>> "Hello {{{}}}!".format("World")
    'Hello {World}!'
    >>> "{{".format("World")
    '{'
    >>> "}}".format("World")
    '}'
    >>> "{}".format("World")
    'World'

It turns out that this is much simpler than I thought it would be. It took me a lot more time to find out. I assume that was because I wasn’t using the appropriate keywords and I ended up reading the manual - which is what I should have done in the first place.

**P.S.:** Immediately after this, I found the [following](https://stackoverflow.com/questions/2847272/python-string-formatting-when-string-contains-s-without-escaping) [StackOverflow](https://stackoverflow.com/questions/19649427/how-can-i-escape-the-format-string) [answers](https://stackoverflow.com/questions/47994397/escaping-str-format-brackets), explaining exactly the same.
