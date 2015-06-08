---
title: How to skip a build
layout: en
permalink: /user/how-to-skip-a-build/
#redirect_from:
#  - /user/how-to-skip-a-build
---

## Not All Commits Need CI Builds

Sometimes all you are changing is the README, the documentation or something else 
which does not affect the tests. In this case you may not want to run a build for
for that commit. 

To skip a build for a particular commit, add `[ci skip]` somewhere in the commit 
message. Commits that have `[ci skip]` anywhere in the commit messages are ignored by 
Travis CI.
