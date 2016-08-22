---
title: Catalyze Deployment
layout: en
permalink: /user/deployment/catalyze/
---

Travis CI can automatically deploy your application to [Catalyze](https://catalyze.io/) after a successful build.

### Setup of Catalyze Deployment Provider

#### Step 1. Get the deployment target for Catalyze:  
1. Make sure your catalyze environment is [associated](https://resources.catalyze.io/paas/paas-cli-reference/#associate).  
2. Get the git remote by running ```git remote -v``` from within the associated repo.  

#### Step 2. Setup a deployment key to Catalyze for Travis CI:  
1. Install the travis-ci cli.  
2. Get the public SSH key for your travis project and save it to a file by running ```travis pubkey > travis.pub```  
3. Add the key as a deploy key using the catalyze cli within the associated repo. For example:  ```catalyze deploy-keys add travisci ./travis.pub code-1```  

#### Step 3. Get the Catalyze public SSH Key:  
1. List your known hosts by running ```cat ~/.ssh/known_hosts```  
2. Find and copy the line from known_hosts that includes the git remote found in step #1. It'll look something like "[git.catalyzeapps.com]:2222 ecdsa-sha2-nistp256 BBBB12abZmKlLXNo..."  

#### Step 4. Update travis.yml

For a minimal configuration, add the following to your `.travis.yml`:

```yaml
before_deploy: echo "CATALYZE SSH HOST FROM STEP 3" >> ~/.ssh/known_hosts
deploy:
  provider: catalyze
  target: "CATALYZE GIT DEPLOYMENT TARGET FROM STEP 1"
```

### Deploying build artifacts

After your tests run and before the deploy, Travis CI will clean up any additional files and changes you made.

Maybe that is not what you want, as you might generate some artifacts (think asset compilation) that are supposed to be deployed, too. There is now an option to skip the clean up:

```yaml
deploy:
  provider: catalyze
  target: "CATALYZE GIT DEPLOYMENT TARGET FROM STEP 1"
  skip_cleanup: true
```

When using `skip_cleanup`, all files in the current working directory are deployed to Catalyze. However, when the `path` option is provided, only the specified files and directories are deployed. In the example below, 'package.json' and all files in the 'build' directory, and it's subdirectories, are deployed.

```yaml
deploy:
  provider: catalyze
  target: "CATALYZE GIT DEPLOYMENT TARGET FROM STEP 1"
  skip_cleanup: true
  path: package.json build  
```

