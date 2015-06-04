---
title: Deploying your iOS app to TestFlight or HockeyApp
layout: en
permalink: ios-deployment/
---

Travis CI can automatically deploy your iOS app to [TestFlight][] or
[HockeyApp][] after a successful build.

To deploy your app using Travis CI, you first need to get code signing working, otherwise the app won't run on any devices.

The first step is to generate a distribution certificate and either an Ad Hoc or In House provisioning profile. If you've already used TestFlight or HockeyApp you should already have this, if not you can check out [Apple's documentation][apple-beta-test-ios].

Now we need to put all of the necessary certificates and provisioning profiles in the repository so Travis CI can access them.

### Apple Worldwide Developer Relations Certification Authority

The Apple Worldwide Developer Relations Ceritification Authority certificate can be downloaded [from Apple][awdrca-cer] or exported from your Keychain using these steps:

1. Open Keychain Access.
2. Search for "Apple Worldwide Developer Relations".
3. Find "Apple Worldwide Developer Relations Certification Authority" in the list and select it. There's probably more than one of them, if they have different expiration dates pick whichever has the last expiration date.
4. Choose File > Export Items and save the certificate somewhere.

Whichever way you choose, put the certificate in `.travis/certs/apple.cer` (you're free to pick a different folder if you want to put your CI-related files somewhere else, but be sure to update the paths later in the guide).

### iOS distribution certificate and private key

The distribution certificate and private key is what's used to actually sign the application. This can also be exported from the keychain like this:

1. Select "My Certificates" in Keychain Access (in the "Category" section of the left sidebar).
2. Find your distribution certificate (usualy named "iPhone Distribution: Your Name"). If you have more than one, you probably want the one with the latest expiration date. Make sure you have the private key associated with the certificate by clicking the arrow next to the certificate name.
3. Export the certificate by selecting it and choosing File > Export Items. Save the certificate in `.travis/certs/dist.cer`.
4. Export the private key associated with the certificate to `.travis/certs/dist.p12`. Make sure to choose a secure passphrase, this is used to encrypt the private key.

Travis CI needs to be able to decrypt the private key, so we need to tell it what the passphrase used to encrypt it was. We can encrypt this passphrase using the [secure environment variables](/usr/encryption-keys/) feature. First [install the `travis` gem](https://github.com/travis-ci/travis.rb#installation) if you haven't already, then run this command:

    travis encrypt KEY_PASSWORD="your password"

Note that if your password contains any characters that might be interpreted by the shell (such as parentheses, curly braces, square brackets, dollar signs, backslashes, etc.), you need to escape them *twice*. Check out our [documentation on encryption keys](/user/encryption-keys/#Note-on-escaping-certain-symbols) for more information.

This command will output something like this:

    Please add the following to your .travis.yml file:

      secure: "a-very-long-string"

    Pro Tip™: You can add it automatically by running with --add.

Add the `secure: "a-very-long-string"` to your .travis.yml under the `env.global` section so it looks like this:

``` YAML
env:
  global:
    - secure: "a-very-long-string"
```

If you already have something in the `env` section of your .travis.yml, you need to move it to `env.matrix` like this:

``` YAML
env:
  global:
    - secure: "a-very-long-string"
  matrix:
    - FOO=bar
```

### iOS provisioning profile

You can download the provisioning profile from [the Apple Developer Center][apple-devcenter-provprofile]. Make sure that this is a distribution profile, not a development profile. Place it in `.travis/profile/`.

Travis CI needs to know the name of the provisioning profile, so we need a few more environment variables:

``` YAML
env:
  global:
    - secure: "the-long-string-from-earlier"
    - APP_NAME="MyApp"
    - DEVELOPER_NAME="iPhone Distribution: Your Name (code)"
    - PROFILE_NAME="My_Profile"
```

The `APP_NAME` variable should be set to the same as your main target. The `DEVELOPER_NAME` should be set to the same as what you see in Xcode under Code Signing Identities > Release in your Build Settings. The `PROFILE_NAME` variable should be the name of the provisioning profile file, without the `mobileprovision` file extension (e.g. if you have a file `.travis/profile/My_Profile.mobileprovision`, you should put `My_Profile` here).

### Encrypting files

Depending on your GitHub project, you may not be comfortable with putting all of these files in "cleartext" in your repository. In that case you can encrypt the files. First come up with a password, we'll choose "foobar", but you should probably pick something more secure. Encrypt the three files using openssl:

# TODO

Figure out how to securely encrypt files. I was looking into `openssl aes-256-cbc`, but I'm not quite confident enough in it yet to document it. It's unauthenticated, which means that we don't know that what we decrypt is the same as what was encrypted etc. Fernet looks like it might be a good choice, but it requires some added dependencies (it's probably possible to do with `openssl` and `base64`, but it would not be pretty).

### Build scripts

Now that we have all the certificates and files that we need, we need to tell Travis CI how to set everything up, build and deploy the app. First, a script to set up the keychain on the Travis CI machine. Put this in a file called `.travis/setup.sh` and run `chmod +x .travis/setup.sh` to make it executable.

``` Shell
#!/bin/bash
# Create keychain, make it default and disable timeout
security create-keychain -p travis travis-build.keychain
security unlock-keychain -p travis travis-build.keychain
security default-keychain -s travis-build.keychain
security set-keychain-settings travis-build.keychain

# Import certificates and keys
security import ./.travis/certs/apple.cer -k travis-build.keychain -T /usr/bin/codesign
security import ./.travis/certs/dist.cer -k travis-build.keychain -T /usr/bin/codesign
security import ./.travis/certs/dist.p12 -k travis-build.keychain -P "$KEY_PASSWORD" -T /usr/bin/codesign

# Install provisioning profile
mkdir -p "$HOME/Library/MobileDevice/Provisioning Profiles"
cp ./.travis/profile/"$PROFILE_NAME".mobileprovision "$HOME/Library/MobileDevice/Provisioning Profiles/"
```

With the keychain set up, it's time to actually build and sign the app. Your tests may already build the app, but that's build for the simulator, and the app needs to be built again for a device. Create another script named `.travis/sign-and-upload.sh` (and run `chmod +x .travis/sign-and-upload.sh`):

``` Shell
#!/bin/bash

if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    echo ">> This is a pull request, not deploying."
    exit 0
fi
if [[ "$TRAVIS_BRANCH" != "master" ]]; then
    echo ">> This is not master, not deploying."
fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/${PROFILE_NAME}.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"

# Build the app (you may need to swap out some arguments here to build the right project/workspace/scheme)
xctool -workspace YourWorkspace.xcworkspace -scheme YourApp -sdk iphoneos -configuration Release OBJROOT=$PWD/build SYMROOT=$PWD/build ONLY_ACTIVE_ARCH=NO

# Package the app (create YourApp.ipa)
xcrun -log -sdk iphoneos PackageApplication "${OUTPUTDIR}/${APPNAME}.app" -o "${OUTPUTDIR}/${APPNAME}.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"
```

Now we need to add all of these scripts to the .travis.yml:

``` YAML
before_script:
  - ./.travis/setup.sh
after_success:
  - ./.travis/sign-and-upload.sh
```

### Deploying

Now that we have the hard part of the way, all that remains is to deploy the app somewhere. First, let's create some release notes. Add this to the end of your `.travis/sign-and-upload.sh` script:

``` Shell
RELEASE_DATE="$(date "+%F %T")"
RELEASE_NOTES="Build $TRAVIS_BUILD_NUMBER
Uploaded: $RELEASE_DATE"
```

You can edit this to include any other information you want in the release notes.


#### TestFlight

Get your [api token][tf-api-token] and [team token][tf-team-token] and add them to your .travis.yml in the `TESTFLIGHT_API_TOKEN` and `TESTFLIGHT_TEAM_TOKEN` environment variables. You probably want to encrypt them using the same method shown above for `KEY_PASSWORD`.

Now we can actually upload the application. Add this to your `.travis/sign-and-upload.sh` script:

``` Shell
curl https://testflightapp.com/api/builds.json \
  -F file="@${OUTPUTDIR}/${APPNAME}.ipa" \
  -F dsym="@${OUTPUTDIR/${APPNAME}.app.dSYM.zip" \
  -F api_token="$TESTFLIGHT_API_TOKEN" \
  -F team_token="$TESTFLIGHT_TEAM_TOKEN" \
  -F distribution_lists="Internal" \
  -F notes="$RELEASE_NOTES"
```

Make sure to choose the right distribution lists. You can send to more than one list by comma-separating the values.

#### HockeyApp

Get the App ID from the app overview page on HockeyApp and [create an API token][ha-create-api-token], then add them to your .travis.yml in the `HOCKEY_APP_ID` and `HOCKEY_APP_TOKEN` environment variables. You probably want to encrypt them using the same method shown above for `KEY_PASSWORD`.

Now we can actually upload the application. Add this to your `.travis/sign-and-upload.sh` script:

``` Shell
curl https://rink.hockeyapp.net/api/2/apps/"$HOCKEY_APP_ID"/app_versions/upload \
  -F status=2 \
  -F notify=0 \
  -F notes="$RELEASE_NOTES" \
  -F notes_type=1 \
  -F ipa="@${OUTPUTDIR}/${APPNAME}.ipa" \
  -F dsym=@${OUTPUTDIR}/${APPNAME}.app.dSYM.zip" \
  -H "X-HockeyAppToken: $HOCKEY_APP_TOKEN"
```

Check out the [HockeyApp API docs][ha-api-docs] for a description of all the parameters.

[TestFlight]: http://testflightapp.com/
[HockeyApp]: http://hockeyapp.net/
[awdrca-cer]: http://developer.apple.com/certificationauthority/AppleWWDRCA.cer
[apple-beta-test-ios]: https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/TestingYouriOSApp/TestingYouriOSApp.html
[apple-devcenter-provprofile]: https://developer.apple.com/account/ios/profile/profileList.action
[tf-api-token]: https://testflightapp.com/account/#api
[tf-team-token]: https://testflightapp.com/dashboard/team/edit/
[ha-create-api-token]: https://rink.hockeyapp.net/manage/auth_tokens
[ha-api-docs]: http://support.hockeyapp.net/kb/api/api-versions#upload-version
