---
title: Multi CPU Builds
layout: en_enterprise

---

## Multi CPU builds

If you wish to build on different multiple CPU architectures (ARM64, IBM PowerPC, IBM Z) and own or manage respective infrastructure, it is possible to do so using Travis CI.

In order to enable the capability of building on multiple CPU architectures, the following requirements are needed:
 
* An appropriate infrastructure with different CPU architecture.
* The ability to run an LXD host over a server with one of the supported CPUs.
* Perform the additional installation steps required for Travis CI Enterprise Worker.
* Configure CPU-specific queues to which newly installed Workers can listen for scheduled jobs.

The MultiCPU environment runs as LXD containers within an LXD host. Once the infrastructure is set up, developers can use it by simply modifying the .travis.yml in the repository.  Please see our [Multi CPU documentation](https://docs.travis-ci.com/user/multi-cpu-architectures/) for usage examples.

Please see [deployment](https://docs.travis-ci.com/user/enterprise/setting-up-worker/) and [configuration](https://docs.travis-ci.com/user/enterprise/worker-configuration/) instructions on preparing Travis CI Enterprise to build against various CPU architectures.
