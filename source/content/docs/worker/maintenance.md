## The worker: maintenance

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

