fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios list_certificates

```sh
[bundle exec] fastlane ios list_certificates
```

List existing distribution certificates

### ios check_env

```sh
[bundle exec] fastlane ios check_env
```

Debug: Check environment variables (for troubleshooting)

### ios certificates

```sh
[bundle exec] fastlane ios certificates
```

Download certificates and provisioning profiles

### ios build

```sh
[bundle exec] fastlane ios build
```

Build and export IPA

### ios upload

```sh
[bundle exec] fastlane ios upload
```

Upload to App Store Connect

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Deploy to App Store (build + upload)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
