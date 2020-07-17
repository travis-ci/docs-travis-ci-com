---
title: Building a MATLAB Project
layout: en

---


### What This Guide Covers

<aside markdown="block" class="ataglance">

| MATLAB                                      | Default                                   |
|:--------------------------------------------|:------------------------------------------|
| [Default `install`](#dependency-management) | N/A                                       |
| [Default `script`](#default-build-script)   | `matlab -batch "results = runtests('IncludeSubfolders',true); assertSuccess(results);" `               |
| [Matrix keys](#build-matrix)                | N/A                                       |
| Support                                     | [MathWorks](mailto:continuous-integration@mathworks.com) |

Minimal example:

```yaml
language: matlab
```
{: data-file=".travis.yml"}

</aside>


This guide covers build environment and configuration topics specific to
[MATLAB&reg;](https://www.mathworks.com/products/matlab.html) and [Simulink&reg;](https://www.mathworks.com/products/simulink.html) projects. Please make sure to read our
[Tutorial](/user/tutorial/) and
[general build configuration](/user/customizing-the-build/) guides first.

{: .warning}
> MATLAB builds are not available on the macOS and Windows environments.


### Community-Supported Warning

Travis CI support for MATLAB is contributed by the community and may be removed
or altered at any time. If you run into any problems, please report them in the
[Travis CI issue tracker](https://github.com/travis-ci/travis-ci/issues/new?labels=matlab)
and cc [@jwpereira](https://github.com/jwpereira), [@mcafaro](https://github.com/mcafaro), and [@acampbel](https://github.com/acampbel).

## Install MATLAB and Run Tests

To run MATLAB code and Simulink models as part of your pipeline, specify the value `matlab` in your `.travis.yml` file.

```yaml
language: matlab
``` 
{: data-file=".travis.yml"}

When you include `language: matlab` in your `.travis.yml`:

* Travis CI installs the latest release of MATLAB on a Linux&reg;-based build agent.
* MATLAB runs the tests in your repository and fails the build if any of the tests fails. 

If your source code is organized into files and folders within a [MATLAB project](https://www.mathworks.com/help/matlab/projects.html), then MATLAB runs any test files in the project that have been labeled as `Test`. If your code does not leverage a MATLAB project, then MATLAB runs all tests in the root of your repository, including its subfolders.

You can override the default test run and generate artifacts by creating a test runner and customizing the runner with the plugin classes in the [`matlab.unittest.plugins`](https://www.mathworks.com/help/matlab/ref/matlab.unittest.plugins-package.html) package. For more information on how to specify and run MATLAB commands, see [Run Custom MATLAB Commands](#run-custom-matlab-commands). 


## Run Custom MATLAB Commands

You can specify the `script` key in your `.travis.yml` to build on the functionality provided by`language: matlab`. To run custom MATLAB commands in your pipeline, use the [`matlab`](https://www.mathworks.com/help/matlab/ref/matlablinux.html) command with the `-batch` option. `matlab -batch` starts MATLAB noninteractively and runs the specified script, function, or statement. For example, call the `disp` function as part of your pipeline.

```yaml
language: matlab
script: matlab -batch 'disp("Hello World")'
``` 
{: data-file=".travis.yml"}

If you need to specify more than one MATLAB command, use a comma or semicolon to separate the commands. 

```yaml
language: matlab
script: matlab -batch 'results = runtests, assertSuccess(results);'
``` 
{: data-file=".travis.yml"}


You can write a MATLAB script or function as part of your repository and execute this script or function. For example, run the commands in a file named `myscript.m` in the root of your repository. (To run a MATLAB script or function, do not specify the file extension.)

```yaml
language: matlab
script: matlab -batch 'myscript'
``` 
{: data-file=".travis.yml"}


MATLAB exits with exit code 0 if the specified script, function, or statement executes successfully without error. Otherwise, MATLAB terminates with a nonzero exit code, which causes the build to fail. You can use the [`assert`](https://www.mathworks.com/help/matlab/ref/assert.html) or [`error`](https://www.mathworks.com/help/matlab/ref/error.html) functions in your code to ensure that builds fail when necessary.


## See Also
[Continuous Integration with MATLAB and Simulink](https://www.mathworks.com/solutions/continuous-integration.html)<br/>
[Continuous Integration (MATLAB)](https://www.mathworks.com/help/matlab/continuous-integration.html)<br/>
[Continuous Integration (Simulink Test)](https://www.mathworks.com/help/sltest/continuous-integration.html)