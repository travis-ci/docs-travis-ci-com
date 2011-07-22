## The worker: overview

Workers consist of the following elements:

* The worker daemon processes which are (currently) based on Resque and execute
  the actual work inside of a VirtualBox VM. These worker processes are managed
  through God.
* The VirtualBox VMs each of which is permanently assigned to a worker process
  through a unique port setting. These VMs are managed through Vagrant, a Ruby
  wrapper for VirtualBox which provides a commandline interface.
* The Chef cookbooks which are used to provision the VirtualBox VMs.

There are a few Thor tasks which can be used to perform maintenance tasks, but
you might need to update files, start workers and/or rebuild or provision VMs
manually. You can check for existing Thor tasks with `thor -T`.

### Vagrant

Vagrant is as a Ruby wrapper for VirtualBox and it has a command line interface
which we use for VM management.

Our strategy for building VirtualBox VMs using Vagrant works as follows:

* Optionally reset *all* VirtualBox settings and VMs, stop all VirtualBox
  daemons.
* Download `lucid32.box` to `~/travis-worker` unless it's already there.
* Import `lucid32.box` as a Vagrant box named `base`.
* Boot up and provision a Vagrant VM named "base" based on this box and using
  the cookbooks.
* Package (export) the provisioned "base" VM to a package named `base.box`
  stored in `~/travis-worker`.
* Import the `base.box` package as Vagrant boxes `worker-1`, `worker-2`, ...
* Boot up Vagrant VMs named `worker-1`, `worker-2`, ...

Warning: you do *not* want to reset VirtualBox with our Thor tasks if you are
using VirtualBox (or Vagrant) for anything else than Travis worker development.
The respective Thor tasks will always ask you though.

### Cookbooks

The Chef cookbooks are used to provision the VirtualBox VMs. They are managed
in a [separate repository](http://github.com/travis-ci/travis-cookbooks) and
cloned to `vendor/cookbooks`.

### VirtualBox

You can use the VirtualBox `vboxmanage` command line interface to manage
VirtualBox VMs directly (i.e. without using the Vagrant interface). This is
sometimes useful for inspecting VM details. Find documentation about `vboxmanage`
[here](http://www.virtualbox.org/manual/ch08.html).

### Sandboxing builds

In order to sandbox executing code from userland we use VirtualBox VM snapshots.

Doing so we will roll back everything to the virgin booted state that is the
result of the provisioning. That means that even git clone'd code and downloaded
rubygems will be gone after the rollback.

To be more precise here's what happens:

* The worker gets a build job from the queue.
* It takes a snapshot from the virgin VM.
* It git-clones the repository, bundle-installs dependencies and runs the build.
* It then powers the VM off (equivalent of pulling the power plug).
* For each existing snapshot it first restores and then deletes it one by one.
  (This is to make sure that in case an uncaught exception has happened all
  snapshots are still restored and deleted).
* It restarts the VM.
* The worker is now ready to wait for the next build job.
