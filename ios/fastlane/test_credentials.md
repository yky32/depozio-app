# Test Fastlane Credentials Locally

To test if your credentials work, run this locally:

```bash
cd ios

# Set your credentials (replace with your actual values)
export FASTLANE_USER="wayneyu.dev@gmail.com"
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="wlet-xvzn-yxrl-evxq"

# Test cert action
bundle exec fastlane run cert username:$FASTLANE_USER team_id:3G34999H3A

# Test sigh action
bundle exec fastlane run sigh username:$FASTLANE_USER app_identifier:com.depozio team_id:3G34999H3A
```

If these work locally but fail in CI, the issue is with how the secrets are set in GitHub.

