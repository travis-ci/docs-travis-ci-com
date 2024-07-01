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
| [Matrix keys](#build-matrix)                | `matlab`, `env`                                       |
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
> Currently, MATLAB builds are available only for public projects in Linux&reg; environments.


### Community-Supported Language

The MATLAB language is maintained by MathWorks&reg;. If you have any questions or suggestions, please contact MathWorks at [continuous-integration@mathworks.com](mailto:continuous-integration@mathworks.com).

## Specify MATLAB Releases and Run Tests

Specify MATLAB releases using the `matlab` key. You can specify R2020a or a later release. If you do not specify a release, Travis CI uses the latest release of MATLAB. 

```yaml 
language: matlab
matlab:
  - latest  # Default MATLAB release on Travis CI
  - R2020a
``` 
{: data-file=".travis.yml"}

When you include `language: matlab` in your `.travis.yml`:

* Travis CI installs the specified MATLAB release on a Linux-based build agent. If you do not specify a release, Travis CI installs the latest release of MATLAB.
* MATLAB runs the tests in your repository and fails the build if any of the tests fails. 

If your source code is organized into files and folders within a [MATLAB project](https://www.mathworks.com/help/matlab/projects.html), then MATLAB runs any test files in the project that have been labeled as `Test`. If your code does not leverage a MATLAB project, then MATLAB runs all tests in the root of your repository, including its subfolders.

You can override the default test run and generate artifacts by creating a test runner and customizing the runner with the plugin classes in the [`matlab.unittest.plugins`](https://www.mathworks.com/help/matlab/ref/matlab.unittest.plugins-package.html) package. For more information on how to specify and run MATLAB commands, see [Run Custom MATLAB Commands](#run-custom-matlab-commands). 


## Run Custom MATLAB Commands

You can specify the `script` key in your `.travis.yml` to build on the functionality provided by `language: matlab`. To run custom MATLAB commands in your pipeline, use the [`matlab`](https://www.mathworks.com/help/matlab/ref/matlablinux.html) command with the `-batch` option. `matlab -batch` starts MATLAB noninteractively and runs the specified script, function, or statement. For example, call the `disp` function using the latest release of MATLAB.

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


You can write a MATLAB script or function as part of your repository and execute this script or function. For example, use MATLAB R2020a to run the commands in a file named `myscript.m` in the root of your repository. (To run a MATLAB script or function, do not specify the file extension.)

```yaml
language: matlab
matlab: R2020a
script: matlab -batch 'myscript'
``` 
{: data-file=".travis.yml"}


MATLAB exits with exit code 0 if the specified script, function, or statement executes successfully without error. Otherwise, MATLAB terminates with a nonzero exit code, which causes the build to fail. You can use the [`assert`](https://www.mathworks.com/help/matlab/ref/assert.html) or [`error`](https://www.mathworks.com/help/matlab/ref/error.html) functions in your code to ensure that builds fail when necessary.


## See Also
[Continuous Integration with MATLAB and Simulink](https://www.mathworks.com/solutions/continuous-integration.html)<br/>
[Continuous Integration (MATLAB)](https://www.mathworks.com/help/matlab/continuous-integration.html)<br/>
[Continuous Integration (Simulink Test)](https://www.mathworks.com/help/sltest/continuous-integration.html)