---
title: JWT addon
layout: en
permalink: /user/jwt/
---

Integration between Travis-CI and third-party services like Sauce Labs relies
on [encrypted variables](http://docs.travis-ci.com/user/environment-variables/#Encrypted-Variables)
which works well for trusted branches and committers.
For security reasons, encrypted variables are not exposed to untrusted pull requests,
so builds of pull requests do not have access to third party integrations.


The JWT addon replaces encrypted variables with a time-limited authentication
token, which is exposed to pull requests without security consequences.

For this to work the JWT addon needs to be enabled in the `.travis.yml` file,
and the third-party need to have integrated with the JWT service and allow
token-based authentication.

<img src="/user/images/travis_jwt.svg" alt="JWT Travis Flow Diagram">


### .travis.yml

Add the encrypted key to the `jwt` section of the `.travis.yml` file.
This can be done manually or using the `travis encrypt` command

Travis Encrypt:

`travis encrypt --add addons.jwt SAUCE_ACCESS_KEY=your-access-key`

Manually:

```yaml
addons:
  jwt:
     secure: <SAUCE_ACCESS_KEY ENCRYPTED>
```

This can also support several services:

`travis encrypt --add addons.jwt SAUCE_ACCESS_KEY=your-access-key THIRDPARTY_SHARED_SECRET=another-key`

Manually:

```yaml
addons:
  jwt:
    - secure: <SAUCE_ACCESS_KEY ENCRYPTED>
    - secure: <THIRDPARTY_SHARED_SECRET ENCRYPTED>
```

### Use the Encrypted Key

The original variable names are available within the Travis CI build as
environment variables containing the JWT tokens instead of the original values.

For example, using the previous configuration `SAUCE_ACCESS_KEY` and
`THIRDPARTY_SHARED_SECRET` will be available as environment variables.

### How secure is this addon?

The JWT token is only valid for 90 minutes. It is signed in a way that lets you securely
transmit your secret information without worrying that it is leaked.

### Troubleshooting

1. Check if the third-party service is [supported](#List-of-Third-Party-Services-Integrated-with-the-JWT-Addon)
2. Contact the third-party support and provide them with the encrypted token (echo the key in your test script), and link to the Travis job.

## Third-Party Service Integration

Third-party service needs to implement a new authentication method on the server side so that the JWT token is recognized and verified.

### JWT Libraries

[JWT.io](https://jwt.io) has a complete list of [supported languages](https://jwt.io/#libraries-io) and documentation on how everything works

### Payload

An example payload used to generate the JWT token:

```javascript
{
  "iss": "Travis CI, GmbH",
  "slug": "saucelabs-sample-test-frameworks/Java-TestNG-Selenium",
  "pull-request": 15,
  "exp": 1470111801,
  "iat": 1470106401
}
```

Where:

 * `slug` will be the travis link slug
 * `pull-request` will be empty(`""`) or the pull request integer
 * `exp` will be when the token expires (now + 5400 seconds, so 90 minutes)
 * `iat` is the issued at time (now)

### Third Party Service Provider Code Sample

A code sample which illustrates how to add JWT token authentication to third party services.

#### Python

In this example we assume the authentication credentials (using environment variables
e.g. `SERVICE_USERNAME` + `SERVICE_ACCESS_KEY`) of a RESTful API will be sent as HTTP BASIC AUTH header:

```
Authorization: Basic am9obmRvZTpleUowZVhBaU9pSktWMVFpTENKaGJHY2lPaUpJVXpJMU5pSjkuZXlKcGMzTWlPaUow\nY21GMmFYTXRZMmt1YjNKbklpd2ljMngxWnlJNkluUnlZWFpwY3kxamFTOTBjbUYyYVhNdFkya2lM\nQ0p3ZFd4c0xYSmxjWFZsYzNRaU9pSWlMQ0psZUhBaU9qVTBNREFzSW1saGRDSTZNSDAuc29RSmdI\nUjZjR05yOUxqX042eUwyTms1U1F1Zy1oWEdVUGVuSnkxUVRWYw==
```

The HTTP BASIC AUTH header's payload is base64 encoded which will decode to string as follows.

```
johndoe:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJ0cmF2aXMtY2kub3JnIiwic2x1ZyI6InRyYXZpcy1jaS90cmF2aXMtY2kiLCJwdWxsLXJlcXVlc3QiOiIiLCJleHAiOjU0MDAsImlhdCI6MH0.soQJgHR6cGNr9Lj_N6yL2Nk5SQug-hXGUPenJy1QTVc
```

The colon separated string contains the username before the colon and the JWT
token after the colon. The username is used to retrieve the user object from
the user database. Below is a function which is executed against the user
object and the token to validate them for authentication. Please note that the
code is deliberately agnostic to what value the access_key contains. It doesn't
matter whether a JWT token or an access key is passed into the function.
However, service providers will have to add the JWT auth attempt to an already
existing authentication mechanism.

```python
import jwt

def authenticate(user, access_key):
    """
    user: db object representing user retrieved based on username from HTTP BASIC AUTH
    access_key: access key or JWT token signed using access key (shared secret)
    returns True when authenication validation passed, otherwise False
    """
    # primary auth method
    if user['access_key'] == access_key:
        return True

    # secondary auth attempt using JWT method
    try:
        return bool(jwt.decode(access_key, user['access_key']))
    except (jwt.DecodeError, jwt.ExpiredSignature):
        return False
```

## List of Third-Party Services Integrated with the JWT Addon

### Sauce Labs

Add your `SAUCE_USERNAME` as a normal environment variable, and your `SAUCE_ACCESS_KEY` as a JWT token
(See [sauce-connect](/user/sauce-connect/) for more details):

```yaml
env:
  - SAUCE_USERNAME=example_username
addons:
  jwt:
    secure: <SAUCE_ACCESS_KEY ENCRYPTED>
```

