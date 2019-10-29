---
title: "DevOps Lisbon, September 2019 - Recap"
date: 2019-10-29T23:04:58Z
draft: false
categories:
    - meetup
---

I intended to write this much sooner but I got distracted and let it slip a lot. It has now been more than a month since I attended DevOps Lisbon in September 2019, and I would like to do a small recap on what went on.

[DevOps Lisbon, September 2019](https://www.meetup.com/DevOps-Lisbon/events/263068633/) happened on 16th of September 2019 and it featured a single talk titled *”An Engineer's Guide to a Good Night's Sleep”* by [Nicky Wrightson](https://www.linkedin.com/in/nicky-wrightson-b2707a1/?originalSubdomain=uk) - Principal Software Engineer at Skyscanner. I have been to a few *DevOps Lisbon* meetups - about two or three - and this was the one I was most excited about. I am deeply interested in the topic and, at the same time, I believe that it is a topic that can be hard to implement in practice, even when theory is understood appropriately.

*”An Engineer's Guide to a Good Night's Sleep”* focused on how to deal with operational issues, on call schedules and callouts at scale. It was structured as a sort-of checklist of commandments, that need to be ingrained in an organizations’ culture, in order to guarantee a stress-free on call experience, with improved operational efficiency in error resolution and monitoring. It is [available on Youtube](https://www.youtube.com/watch?v=LT_8z32ajSQ), with the following abstract:

> In this talk, I will be exploring and discussing some of my top approaches and techniques to help reduce the risk of that dreaded 3am call! You will gain some practical insight into how to handle failure in today's more complex distributed microservice systems. This will include looking at approaches to resiliency, understanding your system, understanding the requirements for fault tolerance, and the developers' mindset necessary for this. I will be peppering this talk with real world examples and an occasional war story along the way too.

As with previous experience, this talk was entertaining and enlightening with clear, practical and concise advice on how to reduce callouts and improve operational maintainability, resilience and flexibility in complex architectures and systems.

In summary, 5 practices were shared:

1. It all starts with the engineers. All teams support how the organization works and each team owns their own support model. Every engineer should think about callout impacts when designing and engineering a solution.
2. Avoid callouts that should have been caught during the day. In particular, Nicky focuses a lot on release planning, management and deploy, as well as improved verification systems.
3. *“Automate, automate, automate”* failure recovery.
4. Understand what are the critical failures, alert only on those and always offer all the necessary information for resolution. *Everything is important,* is never a good mantra.
5. Apply Chaos Engineering to break things and practice teams’ reactions to failures. Practice reacting to failures until reacting is barely necessary.

These 5 clear practices can be very efficient in improving operational resilience of a system but Nicky offers a breadth of advice, in each topic, that I didn’t convey *at all* in this summary. She uses real world situations and events, improving the delivery of the message and our understanding of these concepts and practices. It was a brilliant talk, both in in its delivery and in its contents, and everyone should watch it on Youtube if you can.

