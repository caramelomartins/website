---
title: "Keeping an SSH Connection Alive from a Client"
date: 2018-04-05T00:00:00+01:00
draft: false
summary: Sometimes you run scripts that take a lot of time to finish, through SSH. Also, the server, sometimes, closes your connection. This is bound to create issues. I have recently faced similar issues and went searching for a possible solution.
categories:
    - ssh
---

Sometimes you run scripts that take a lot of time to finish, through SSH. Also, the server, sometimes, closes your connection. This is bound to create issues. I have recently faced similar issues and went searching for a possible solution.

Turns out that there's a simple solution for this. From `ssh_config` [1]: 

> ServerAliveInterval
Sets a timeout interval in seconds after which if no data has been received from the server, ssh(1) will send a message through the encrypted channel to request a response from the server. The default is 0, indicating that these messages will not be sent to the server. This option applies to protocol version 2 only. 

Open `~/.ssh/config` on an editor and type:

```
Host example.com
    ServerAliveInterval 300
```

This will send a message to the server every 300 seconds (5 minutes) which will keep your connection alive. You can tweak that value to something that works out best for each use case. If you want to apply this to all hosts just replace `example.com` with `*`.

This is a pretty simple way of avoiding connections closed, when using `nohup` or `&` is not an option.

# References

[1] https://linux.die.net/man/5/ssh_config
