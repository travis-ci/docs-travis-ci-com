---
title: The worker
layout: default
permalink: worker/
---

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

## Maintenance

### Setting up a new worker box

Currently needs to be done manually. <span class="help">Automate this if you'd like to help!<span>

The box should have a user `travis` and the following things installed.

* Ubuntu Lucid32 2.6.32 (the exact kernel version matters!)
* VirtualBox 4.0.10r72479
* Git
* Ruby 1.9.2 (preferably using Rvm)
* Rake, Bundler, God, Vagrant

Install `travis-worker`:

* `$ git clone` the travis-worker repository to `~/travis-worker`
* `$ cd ~/travis-worker`
* `$ cp config/worker.example.yml config/worker.yml`
* `$ bundle install`

Now edit `config/worker.yml` according to your requirements. You might also need
to create a file `config/worker.[environment].yml` unless it is already there
for your environment. This (version controlled) file is merged with your (local)
`config/worker.yml` file. The latter takes precedence so you can overwrite any
of the settings in your `config/worker.yml` file.

You might want to pay special attention to:

* the Redis URL (this is the Redis instance used by the Travis application)
* the Travis application URL (you need to add your Travis username and token
  here)
* the number of workers (`vms`) that will be used (e.g. you might want 1 for
  VM/cookbook development and 5 for staging/production use).
* the Chef cookbook recipies that will be provisioned to each VM.

That should be all. You can now build the VMs and then start the workers.

### (Re-) Building the worker VMs

Before you start working on VMs you want to stop the workers in production and
maybe staging! See below for instructions.

You might want to (re-) build all VMs in the following cases:

* You are setting up a new worker server box.
* There are significant changes to the cookbooks and you want to restart from
  scratch.
* For some reason VMs are broken or don't boot and you want to rebuild them.

For (re-) building all worker VMs use the following Thor task:

    $ thor travis:worker:vagrant:rebuild

Warning: you will be asked if you want to reset the VirtualBox environment
(including *all* settings and *all* existing VMs).

Do *not* answer `yes` here if you are using Vagrant/VirtualBox for anything else
than Travis worker development! If you are using Vagrant/VirtualBox *exclusively*
for Travis worker development then you can just always reset VirtualBox (i.e.
answer `yes`) with this Thor task.

### Starting and stopping workers with God

For production/staging use God should be used to manage workers:

    $ god -c .worker.god                 # start up god with the worker configuration file
    $ god [start|stop|restart] workers   # start/stop/restart all workers
    $ god [start|stop|restart] worker-1  # start/stop/restart a single worker
    $ god terminate                      # terminate god and stop all workers
    $ god load .worker.god               # reload the configuration

### Starting a worker manually

For development you might want to run the worker process manually:

    $ QUEUE=builds TRAVIS_ENV=development VM=worker-1 VERBOSE=true bundle exec rake resque:work --trace

Change the `QUEUE`, `TRAVIS_ENV` and `VM` vars according to your setup.

### Adding more workers

If you have started out experimenting with just one worker and VM, are happy
with things and want to increase the number of workers/VMs now then you can do
that as follows:

* Edit `config/worker.yml` and set the number of VMs to the target number.
* Add the additional Vagrant boxes by running `$ thor travis:worker:vagrant:import`.
  This will show you an error message for each of the existing boxes that can
  not be overwritten. You can simply ignore these messages.
* Boot the additional VMs by running `$ vagrant up`.

Now `$ vagrant status` should show you the same number of VMs as you've specified
in your `config/worker.yml` and they should be all running.

You also need to update God with the new configuration and restart the worker
processes:

    $ god load .worker.god

### Reprovisioning the worker VMs

Before you start working on VMs you want to stop the workers in production and
maybe staging! See below for instructions.

With our stategy used for building VMs like described above there are two ways
to provision cookbook changes to the worker VMs:

* Simply provision the worker VMs
* Provision the base VM, re-export it to base.box, remove all worker base boxes,
  re-add base.box as new worker base boxes, destroy all VMs, start new worker
  VMs. <span class="help">Automate this if you'd like to help!<span>

The first approach provisions on each of your VMs, so if you have 5 VMs it will
provision 5 times. The second approach only provisions on the base VM and then
use this state as the base for the worker VMs.

Reprovisioning a VM even without any changes to the cookbooks will take some time
because various things need to be checked inside of the VM to ensure the
installation is in sync with the cookbooks.

With 5 VMs and no changes to the cookbooks provisioning might take something
like 5-10 mins depending on the recipes used. If you are adding 2 more Rubies to
5 VMs though then this will run for about 100 mins (~10 mins per Ruby * 2 * 5)
with the first approach, whereas the second approach would only take 20 mins.

### Stop workers before working on VMs

Before you start working on VMs you want to stop the workers in production and
maybe staging. Here's how you can do that:

    $ thor travis:worker:resque:stop  # this will stop the workers but wait for current jobs to be finished (might take a little while)
    $ ps aux | grep resque            # check that all worker processes actually have quit (they should!)
    ...                               # work on the VMs
    $ thor travis:worker:resque:start # start the workers


