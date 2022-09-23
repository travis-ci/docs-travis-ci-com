---
title: Hashicorp Vault Integration
layout: en

---

Hashicorp Vault is a Key Management System (KMS), which allows to self-manage the set of secrets (credentials), configuration items and access to these.

Travis CI may obtain secrets needed during the build, test, or deployment stages of your Travis CI builds from your Hashicorp Vault instance instead of storing them with Travis CI.

This may be useful if your organization leans towards having complete access control to the secrets or wants to conveniently manage secrets necessary in the CI/CD pipeline in one Key Management System (KMS).

## Prerequisites

You will need:

* An URL for Hashicorp Vault instance with enabled KV engine and supporting KV2 API (see [Hashicorp Vault  documentation](https://www.vaultproject.io/api-docs)).
  * The Hashicorp Vault instance API must accept incoming requests from a public network; see our [IP Addresses page](/user/ip-addresses/) for information on what exactly must be allowed and a couple of recommendations on configuring the network rules.
* A path to the required secrets in Hashicorp Vault.
* A token; [obtained after logging into Hashicorp Vault](https://www.vaultproject.io/docs/concepts/auth#tokens) via API/or via Hashicorp Vault CLI (keep it secret!).
  * Before trusting Travis CI with the token, we recommend reviewing the Hashicorp Vault account access to the set of secrets; a best practice is to limit it to projects needed for the build/test/deployment tasks you want Travis CI to perform. Please consider a dedicated account in Hashicorp Vault with access to a limited set of  CI/CD related secrets.
* Encrypt token with Travis CI for further usage
  * Please use travis-cli to [encrypt the secret](/user/encryption-keys/) and use the encrypted string in your `.travis.yml` file; in the initial release, we have consciously limited this to be the only way to provide an access token to your KMS

## How does the integration work?

The integration is based on communication with Hashicorp Vault API. The only secret stored in Travis CI will be the access token (in encrypted form).

> If you are using a dedicated Hashicorp Vault account and a secret is to be shared among multiple repositories, we suggest considering managing the Hashicorp Vault access token by storing it in one repository in your organization and [import it to other repositories build configurations](/user/build-config-imports/). Thus you may manage the Hashicorp Vault access token centrally. However, please mind that imported shared configurations will be available for all jobs in the build matrix.

First, define a simple set of items in the `.travis.yml` for your repository. Then, once Travis CI processes the build request, the following steps occur:
* First, the access token is decrypted for the duration of the build.
* At the start of a specific build job, secrets defined in the `.travis.yml` are downloaded into the specific build job and are censored for the build job log (in order to not expose these accidentally).
  * Secrets will be present for the duration of the specific build job, limiting the time these can be used. Therefore, please consider obtaining secrets from Hashicorp Vault and processing them in as few build jobs in the [job matrix](/user/build-matrix/#explicitly-including-jobs) as possible,  on an as-needed basis.
  * Secrets are obtained from the ‘secrets’ node in the Hashicorp Vault.
  * Only defined secrets are obtained; if no secret paths are defined, nothing is acquired from the Vault instance.
* Hashicorp Vault secrets in the KV engine do come as key-value pairs. The secret key is turned into an environmental variable name within the Travis CI build job; the secret value is the value of the environment variable.
  * Please note: if duplicate keys are present in the Hashicorp Vault and are obtained via definition in the `.travis.yml`, the last obtained value will overwrite the previous ones; the sequence of appearance in `.travis.yml` is processed from top to bottom.
  * The environment variable consists of the last reference in the path, plus a secret key, e.g., if in the Hashicorp Vault a  /ns1/project_id/secret_key_a secret secret with key ‘message’ is present, the environmental variable name created within Travis CI build job will be:  SECRET_KEY_A_MESSAGE
* Once the secrets are obtained, you may use them within your build job; the value of the secrets will be censored in the Travis CI build job log.

## Usage

Travis Ci introduces a new `vault` node to `.travis.yml`. It can be used at the root level of the file or as a part of the job matrix.

```yaml
# use vault node to configure connection and secrets obtained from the Hashicorp Vault
vault:
  api_url: https://[your hashicorp vault endpoint here]
  token:
    secure: "..." # encrypted token value, alphanumeric string
  secrets:         # configure which secrets to obtain
# either define it via calling out the Hashicorp Vault namespace and providing relative paths to the secrets/namespace
    namespace: ns1
      - project_id/secret_key_a
      - project_id/another_key
# or define it by providing a list of paths relative to the ‘secrets’ node in the Hashicorp Vault
    - ns1/project_id/secret_key_a
    - ns1/project_id/another_key
# Remember always to obtain only secrets necessary for the specific build job!
```
{: data-file=".travis.yml"}

See usage examples  below:

#### Single `.travis.yml` file 

**As a data accessible for all jobs in the build definition:**

```yaml
os: linux
dist: focal

# vault data at the root level of `.travis.yml` makes it available for all jobs in the build
vault:
  token: 
    secure: "Your encrypted token goes here."
  api_url: https://your-vault-api.endpoint
  secrets:
    - ns1/project_id/secret_key_a 

script:
#assuming that under /ns1/project_id/secret_key_a a secret with key ‘message’ is present
  - echo $SECRET_KEY_A_MESSAGE 
```
{: data-file=".travis.yml"}

**As a datat accessible only within one of many jobs:**

```yaml
os: linux
dist: focal

jobs:
  include:
    - name: “Vault job” # make vault secrets and connections only in this job
      vault:
        token: 
          secure: "Your encrypted token goes here.”
        api_url: https://your-vault-api.endpoint
        secrets:
          - ns1/project_id/secret_key_a
      script:
        - echo $SECRET_KEY_A_KEYNAME
    - name: "Another job" # this env variable contains nothing
      script: 
        - echo $SECRET_KEY_A_KEYNAME

```
{: data-file=".travis.yml"}

#### Imported shared build configuration

```yaml
vault:
  token: 
    secure: "Your encrypted token goes here."
  api_url: https://your-vault-api.endpoint
```
{: data-file=".vault-secret.yml"}

```yaml
import:
  - source: vault-secrets.yml  
    mode: deep_merge_prepend #deep_merge for overwriting the values in vault-secrets.yml 

os: linux
dist: focal

jobs:
  Include:
    - name: "Vault job utilizing imported values job" # vault connection details come from imported vault-secrets.yml
        secrets:
          - ns1/project_id/secret_key_a
      script: 
        - echo $SECRET_KEY_A_MESSAGE
    - name: “Vault job overwriting imported values.”
      vault:
        token:   
          secure: "another encrypted token goes here.”
        api_url: https://different-vault-api.endpoint
        secrets:
          - ns1/project_id/secret_key_b
      script:
        - echo $SECRET_KEY_B_SOMEKEY
```
{: data-file=".travis.yml"}


Please note: imported content is available for your whole build (`.travis.yml`) unless it’s overridden explicitly by some of the jobs in your `travis.yml`. The YAML anchors cannot be imported and used in the main `.travis.yml` - read more about it on the [Importing Shared Build Configuration](/user/build-config-imports/) page.

## FAQ

### Can I define the Hashicorp Vault token in the UI as an environment variable?

Not at the moment. For now, as a mandatory practice, we keep a restrictive rule of a token to your Hashicorp Vault forcibly provided as a Travis CI `secret`. However, we would like to minimize the risk of accidentally leaking your secrets while enforcing the practice of securing particularly vulnerable data such as access tokens to your Key Management System. Thus, if you define the environment variable in the UI, the build job will not connect to the Vault if it doesn't see a `vault.token.secure`. And it will, by default, prevent printing out its decrypted content in the build job log regardless of the option in the UI (Repository Settings).

Since there are always ways to work around security measures, we want to hear from you and see if the constraint of being able to add a Vault token only under `vault.token.secure` should be relaxed in the future.

### Can I share the Hashicorp Vault token as an encrypted environment variable with a forked repository?

Not at the moment. In the future, we plan to allow it to be shared with a forked repository (for a collaboration model when Pull Requests are filed from forked repositories to the base repository). However, we intend to watch for your feedback on the matter first for some time.

### Is the KV2 API only Hashicorp Vault secret key-value API version supported?

There’s built-in support for KV API in order to be able to support older installations. However, it has not been extensively tested. Use at your discretion and risk:

```yaml
vault:
  api_url: url
  token:
    secure: secure_token
  secrets:
    - kv_api_ver: kv1 #optional, kv1 or kv2, default is kv2, single value
    - project_id2/secret_key
```
{: data-file=".travis.yml"}
