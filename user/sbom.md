---
title: Software Bill of Materials
layout: en

---

The SBOM (Software Bill of Materials) is a file or set of files describing the dependencies included in the released software. It serves the purpose of indexing components used in the release in a usable format, e.g., security teams. Being able to generate and deliver SBOM once your software is built, tested, and ready to deliver/delivered by Travis CI helps to conform with secure software supply chain policies.

Travis CI allows the generation of SBOM files for certain programming languages. Travis CI generates the SBOM from thesource code that triggers a build. The SBOM files can be generated at a certain phase of a build job, and the user must upload them to the target location by, e.g., providing proper instructions in the `.travis.yml` file.

Alternatively, users can download specific SBOM generators to the build job environment and customize the SBOM generation process as much as needed via `.travis.yml`. As a matter of fact, in specific scenarios, this could be the best way forward. Travis CI provides an ease-of-use enhancement for popular build scenarios.

## How does SBOM work?

SBOM is generated utilizing [CycloneDX](https://cyclonedx.org/tool-center/) plugins for certain languages and [Syft](https://github.com/anchore/syft/) attempting to cover the remaining use cases.
The way it works is very simple:

1. Travis CI user puts in the `.travis.yml` in the repository for a specific build job, which should build SBOM
    1. new `addons.sbom` instructions.
    2. Additional instruction, e.g., using Travis CI [DPL](/user/deployment/), or [DPLv2](/user/deployment-v2/), or custom commands to deploy or move generated SBOM files to the desired target location.
2. The build and respective build job run on Travis CI; appropriate tooling is downloaded into the build job and runs according to `.travis.yml` entries.

The SBOM generation is available under Linux build environments (for Linux build jobs).


## Supported languages and package managers

Currently, you can generate SBOM for the following programming languages in your repository, assuming certain package managers used.

 * Ruby
 * Python
 * Go
 * Node.js / JavaScript and NPM
 * PHP

The tooling will attempt to use respective CycloneDX plugins for the above combinations.
For the remaining languages, Travis CI will run Syft to build SBOM.

The default output of the SBOM file is a CycloneDX-compatible JSON. However, it is possible to request CycloneDX-compatible XML or SPDX JSON.


## Trigger SBOM generation

There’s a new node in the existing `addons` section added specifically to help handle SBOM generation instructions.

The simplest call would look like this:

```yaml
jobs:                             # existing functionality
  include:                        # existing functionality
    - os: linux
      dist: focal
      name: "SBOM generation example job"
      addons:
         sbom                    # new node
         <other existing addons>
```
{: data-file=".travis.yml"}

The above job definition would trigger a job named 'sbom' that will generate the SBOM file(s) out of the repository source. To take advantage of SBOM generation, one can use some additional parameters one can use to manage the SBOM generation process.

```yaml
jobs:
  include:
    - os: linux
      dist: focal
      addons:
        sbom:                                          # new node
          on:
            branch: 'branch_name_here'                 # branch of the repository
          run_phase: 'after_success'                   # when SBOM generation should be executed; see below
          output_format: 'cyclonedx-json'              # SBOM file(s) output format
          input_dir: '/sbom/ruby'                      # relative paths within build job environments, see below
          output_dir: '/sbom/ruby'
```
{: data-file=".travis.yml"}

The new `sbom` node has the following available properties:

* `on.branch` - by default, the SBOM generator is enabled for commits triggering builds from all branches. However, this may not be the desired state of things, and therefore, here, a user can provide a branch name to limit SBOM generation to, e.g., *release* branch builds.
* `run_phase` - refers to a build job phase. [Builds have stages grouping jobs, and jobs have specific phases](/user/for-beginners/#builds-stages-jobs-and-phases). By default, the SBOM generation is set to run in *on_success* job [lifecycle phase](/user/job-lifecycle/#the-job-lifecycle) (assuming one would want to generate SBOM for a successful build & test run in case of single job build). Allowed values are:
    * `before_script` - before the script phase
    * `script` - usually main build job instructions phase
    * `after_success` (DEFAULT value) - when the build job succeeds, the result is available in the TRAVIS_TEST_RESULT environment variable
    * `after_failure`
*  `output_format` - defines the SBOM format for the output file(s). By default this is set to *cyclonedx-json*. Allowed values are:
    * `cyclonedx-json` - CycloneDX SBOM format, JSON file
    * `cyclonedx-xml` - CycloneDX SBOM format, XML file
    * `spdx-xml` - SPDX SBOM format, XML file
*  `input_dir` - is an input source code directorycontaining a package manager file corresponding to the programming language. It is relative to the build job environment. The default path for SBOM input is the build input directory */home/travis/build/<repository slug>*. However, if specific software source code parts are kept in repository subdirectories (e.g., frontend or backend of application or, e.g., */lib* subdirectory), one may want to generate SBOM only over this subdirectory. In order to do that, `input_dir: /<repository subdirectory>` (which would take as input directory the */home/travis/build/<repository slug>/<repository subdirectory>*) should be explicitly provided.
*  `output_dir` - this is the output directory, where SBOM file(s) are placed once the SBOM generation is finished. The default output path should is */home/travis/build/<repo slug>/sbom-<TRAVIS_JOB_ID>* where TRAVIS_JOB_ID is a [default environment variable](/user/environment-variables/#default-environment-variables) present in the build job. If this parameter is used, e.g., `output_dir: /my_subdir` is provided, the SBOM files are placed in a subdirectory  relative to */home/travis/build/<repo slug>/*, e.g., in `/home/travis/build/<repo slug>/my_subdir`

## Deploy SBOM files to target location

Travis CI does not maintain an SBOM registry. Every user is free to take the generated SBOM files from the `output_dir` location and transfer them to the selected destination via proper instructions placed in the `.travis.yml`.

> Please note: Transferring SBOM files must be defined in the build job phase occurring **after** the SBOM is generated!

Please remember that Travis CI build job environments are ephemeral, and once the build job is finished, the environment is destroyed. Thus if SBOM file(s) are to be sent or deployed, the deployment step must occur in the same build job in which SBOM files were generated.

It is possible to use Travis CI [deployment](/user/deployment/) functionality to keep the instructions in `.travis.yml` consistent and deploy SBOM file(s) alongside your release package. An example of deploying generated SBOM files could be as follows:

```yaml
jobs:
  include:
    - os: linux
      dist: focal
      name: SBOM Ruby
      os: linux
      language: ruby
      script:
        - gem build ./sbom/ruby/hello_world.gemspec
      addons:
        sbom:
          on:
            branch: 'sbom'
          run_phase: 'after_success'
          output_format: 'cyclonedx-json'
          input_dir: '/sbom/ruby'
          output_dir: '/sbom/ruby'
      deploy:
        - provider: releases    # deploying to GitHub Releases
          edge: true
          file_glob: true
          file: sbom/ruby/**/*
          skip_cleanup: true
          on:
            branch: sbom
        - provider: s3          # deploying to target AWS S3 Bucket
          edge: true
          bucket: "sbom-test"
          skip_cleanup: true
          local_dir: sbom/ruby
          on:
            branch: sbom
```
{: data-file=".travis.yml"}

See more examples in our [test repository](https://github.com/travis-ci/travis-tests/blob/sbom/.travis.yml#L44-L158).


## Remarks

If multiple SBOM files are generated, pack them into a single file before sending them to the target location.
For security reasons, if you are outputting the SBOM file(s) content to the build job log, you may want to limit access to such job logs. [Read more](/user/disable-job-logs/#limiting-access-to-build-job-logs).
Consider signing your release and SBOM file(s) before deploying the package. [Read more](/user/securely-signing-software).
