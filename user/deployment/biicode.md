---
title: biicode deployment
layout: en
permalink: /user/deployment/biicode/
---

<div class="note-box">
Note that the biicode provider requires <code>sudo</code>.
Consequently, it is not available for builds that are running on the <a href="/user/workers/container-based-infrastructure">container-based workers</a>.
</div>

Travis CI can automatically publish your [biicode](https://www.biicode.com) blocks after a successful deploy.

For a minimal configuration, all you need to do is add the following to you `.travis.yml`:

{% highlight yaml %}
deploy:
  provider: biicode
  user: "YOUR_USER"
  password: "YOUR_PASSWORD" # should be encrypted
{% endhighlight %}

Install Travis CI command line client to encrypt your password like this:

{% highlight console %}
$ travis encrypt "YOUR PASSWORD" --add deploy.password
{% endhighlight %}

You can also have the `travis` tool set everything up for you:

{% highlight console %}
$ travis setup biicode
{% endhighlight %}

Keep in mind that the setup command has to run in your project directory, so it can modify the `.travis.yml` for you.

### Branch to deploy from

You can also explicitly specify the branch to deploy from with the **on** option:

{% highlight yaml %}
deploy:
  provider: biicode
  user: ...
  password: ...
  on: production
{% endhighlight %}

Alternatively, you can also configure Travis CI to deploy from all branches:

{% highlight yaml %}
deploy:
  provider: biicode
  user: ...
  password: ...
  on:
    all_branches: true
{% endhighlight %}

Builds triggered from Pull Requests will never trigger a deploy.

### Deploying build artifacts

After your tests ran and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts that are supposed to be deployed too (like dependencies' data). There is an option to skip the clean up:

{% highlight yaml %}
deploy:
  provider: biicode
  user: ...
  password: ...
  skip_cleanup: true
{% endhighlight %}

### Conditional Deploys

You can run deploy only when certain conditions are met.
See [Conditional Releases with `on:`](/user/deployment#Conditional-Releases-with-on%3A).

### Running commands before and after deploy

You can use the `before_deploy` and `after_deploy` stages to run commands just before and after the deploy is done. These will only be triggered if Travis CI is actually deploying.

{% highlight yaml %}
before_deploy: "echo 'ready to publish?'"
deploy:
  ..
  after_deploy:
    - bii deps --detail
{% endhighlight %}

### Using biicode in your deploy

Add this to your `install:` entry to install biicode in your build machine:

{% highlight yaml %}
install:
  - wget http://apt.biicode.com/install.sh && chmod +x install.sh && ./install.sh
  - bii setup:cpp
{% endhighlight %}

This downloads a script to install biicode on Debian-based distros, as explained in [biicode docs](http://docs.biicode.com/c++/installation.html#alternative-install-debian) and executes a biicode command to set up required tools for C/C++ development. It actually installs CMake.

Now you're ready to use biicode in the build virtual machine. All biicode commands are available. Note: build changes made before performing the deploy are discarded except disabled with the `skip_cleanup` flag (See *"Deploying build artifacts"*).

It's a good practice to check biicode's version after installing:

{% highlight yaml %}
install
  ...
  - bii --version
{% endhighlight %}


### A simple biicode deployment example step by step

Let's say you have a C++ math library called *CppMath*. It's hosted in github and you are running some unit tests via Travis CI.
Deploy your CppMath library to biicode, a C and C++ dependency manager, make it available for everybody to use via an `#include`!

Use Travis CI with biicode to automate the process:

  - Run some unit tests on the library
  - Use `bii publish` command to deploy to biicode.

Here's [CppMath example code](https://github.com/Manu343726/CppMath/), it's structured as a `manu343726/cppmath` biicode block. *manu343726 is the biicode developer who wrote the example, hence that user instead of `developer`.*

Supposing your biicode account is `developer`, create a `.travis.yml` file to automate deploy and publish like this:

{% highlight yaml %}
install:
  - wget http://apt.biicode.com/install.sh && chmod +x install.sh && ./install.sh #Install biicode
  - bii setup:cpp #Install biicode required C/C++ tools (GCC, cmake, etc)
script:
  - bii find --update #Find biicode dependencies
  - bii cpp:configure #Configure block for building
  - bii cpp:build #Build block
  - ./bin/developer_cppmath_tests --reporter=info #Run tests
deploy:
  provider: biicode
  user: developer
  password: #password
    secure: encrypted password here
  on:
    repo: developer/cppmath #GitHub repo
{% endhighlight %}

`install:` installs biicode and configures C++ tools. `script:` creates, builds and runs the project. If it's a success Travis CI executes deploy publishing the `developer/cppmath` block.

>**Tip**
>biicode generates an executable `user_blockname_sourcefilename` for each source file with a `main()` function. In the example it would be `developer_cppmath_tests`.
