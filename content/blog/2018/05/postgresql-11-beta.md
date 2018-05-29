---
title: "PostgreSQL 11 (Beta)"
date: 2018-05-29T00:00:00+00:00
draft: false
categories:
    - postgresql
---

PostgreSQL 11 (Beta) is out [1] with some very interesting features worth taking a look at. PostgreSQL is already my go-to relational database and - no science to support that - is the easiest, most performant relational database management system. I've tried MySQL, Oracle and SQL Server which, in reality, might be a signal that my standards are not very high. Nonetheless, I'm always happy when I see a new release of PostgreSQL. I've based my analysis by skimming through the release notes [2].

There's been some interesting updates, performance-wise. These have been announced on the release home page [1]. It seems that partitioning and parallel operations have been improved, through allowing new actions or actual performance improvements in current functionality.

Apart from parallel operations and partitioning, there's also some interesting performance improvements for indexing, such as allowing hash index pages to be scanned, or useful features, such as including columns in indexes that are not part of unique constraints but might be available for "index-only scans". Another announced change is the introduction of a Just-In-Time compiler which is supposed to speed up some parts of the query plan which, in turn, will improve the query execution. This JIT compiler is based on LLVM [3]. I expect that this is going to introduce some interesting speedups, specially when analyzing WHERE statement (like the documentation suggests). I'll be interested in understanding, further down the road, the impact this feature actually has - one way to use this is to run EXPLAIN as it should indicate JIT usage.

The most interesting points for me are security related, of course, and it seems that PostgreSQL keeps improving in that regard too.  There's been an improvement over the ability to specify complex LDAP specifications and we can now use LDAP through TLS, which is an interesting improvement, since it means we can run LDAP integration through encrypted channels. Some roles and permissions have been created to perform sensitive operations - accessing the file system and large object importing/exporting - that were previously only controlled through super users, which means that we have better tools to manage access control, with more precise policy implementations over user's abilities.

I have only spoken about a handful of changes, related to performance and security, but there's been a lot of them! These release notes spread across twelve different modules and there's been news in regards to almost every section of PostgreSQL, either with bug fixes or new functionality.

## References

[1] https://www.postgresql.org/about/news/1855/

[2] https://www.postgresql.org/docs/devel/static/release-11.html

[3] https://www.postgresql.org/docs/devel/static/jit.html
