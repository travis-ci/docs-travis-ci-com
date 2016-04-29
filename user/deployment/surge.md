---
title: Surge.sh Deployment
layout: en
permalink: /user/deployment/surge/
---

Travis CI can deploy your static files to [Surge.sh](https://surge.sh/) after a successful build. Builds triggered from Pull Requests will never trigger a deploy.

You will need to set 2 environment variables in your travis settings and set the deployment provider details in `.travis.yml`

### Environment variables

* **SURGE_LOGIN**: Set it to the email address you use with Surge
* **SURGE_TOKEN**: Set it to your login token (get it by doing a `surge token`)

### Configuration of `.travis.yml`:

- Add `surge` as deployment provider in `.travis.yml`

- If your project folder is not the repo root you can set the deploy option `project` to define a path relative to repo root to deploy.

- If you do not have a `CNAME` file with the name of the domain to publish to you can set the deploy option `domain` with the domain to deploy to. 

Example: 

```yaml
deploy:
  provider: surge
  project: ./static/
  domain: example.surge.sh  
```

### Generated content

If you would like to deploy content thats generated during the Travis CI run you have two options: 

- A) generate it during the "test" step. A failed script will give a failed travis run
- B) generate it at the "before_deploy" step. A failed script will still give a successful travis run

If you use A) you must ask Travis to keep the generated files instead of resetting the repo before deploy:

```yaml
deploy:
  ... 
  skip_cleanup: true
```


### Branches

By default, Travis CI will only deploy from your `master` branch. You can pecify what branch to deploy from with the deploy option `on`:

```yaml
deploy:
  ...
  on: myProductionBranch
```

To deploy from all branches set the deploy->on option `all_branches` to `true`

```yaml
deploy:
  ...
  on:
    all_branches: true
```
