---
title: "Travis CI finally archives logs to S3"
created_at: Tue Jan 29 17:00:00 CET 2013
layout: post
author: Sven Fuchs
twitter: svenfuchs
permalink: blog/2013-01-29-archive-logs-to-s3
---

## Archive all that stuff, finally



Last week we have made a tiny change to a worker payload which eventually bogged down our API almost entirely. As [Rick Branson](https://twitter.com/rbranson/status/261139185694568449) said: "Keeping distributed systems running smoothly seems to be mostly about figuring out ways to not DDoS yourself."

Our worker heartbeats started sending updates to the UI via Pusher on every single heartbeat. The UI in turn recognized that there's an attribute missing and turned to the API in order to complete the data. Obviously this multiplied the worker heartbeats by an unknown number of clients (open browsers) and bombed down our API.

Actually the API most probably would even have survived this easily if there wasn't also a very long running backup query running (which was busy copying our logs database table for hours) as well as a very long list of jobs in the queues (which we still fully delivered to the client). As soon as we've killed this query deliberately API again was somewhat usable. Adding a limit to the list of jobs displayed on the UI further improved things and, finally, adding the missing attribute to the worker JSON payload fixed it.

But this incident also was the last straw to finally do something about our database size which had been growing rapidly over the last months.


