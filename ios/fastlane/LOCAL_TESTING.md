# Local Fastlane Testing Guide

## Quick Start

### Option 1: Using App Store Connect API Key (Recommended)

1. **Set up API key environment variables:**
   ```bash
   cd ios
   export APP_STORE_CONNECT_API_KEY_ID="your_key_id"
   export APP_STORE_CONNECT_ISSUER_ID="your_issuer_id"
   export APP_STORE_CONNECT_API_KEY_CONTENT="$(cat ~/path/to/AuthKey_XXX.p8)"
   ```

2. **Run the build:**
   ```bash
   bundle exec fastlane build
   ```

### Option 2: Using Apple ID (Update Password First)

1. **Update `fastlane/env.default` with correct credentials:**
   - Get a new app-specific password from: https://appleid.apple.com
   - Update `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` in `env.default`

2. **Load environment and run:**
   ```bash
   cd ios
   source fastlane/env.default
   export FASTLANE_USER FASTLANE_PASSWORD FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
   bundle exec fastlane build
   ```

## Prerequisites

1. **Install dependencies:**
   ```bash
   cd ios
   bundle install
   ```

2. **Install CocoaPods dependencies:**
   ```bash
   cd ios
   pod install
   ```

3. **Set up Flutter (if not already):**
   ```bash
   flutter pub get
   ```

## Testing Individual Lanes

### Check Environment Variables
```bash
bundle exec fastlane check_env
```

### List Certificates
```bash
bundle exec fastlane list_certificates
```

### Download Certificates Only
```bash
bundle exec fastlane certificates
```

### Build Only (requires certificates first)
```bash
bundle exec fastlane build
```

### Upload Only (requires build first)
```bash
bundle exec fastlane upload
```

### Full Deploy (certificates + build + upload)
```bash
bundle exec fastlane deploy
```

## Troubleshooting

### "Invalid username and password combination"
- Generate a new app-specific password at https://appleid.apple.com
- Update `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` in `env.default`
- Or use App Store Connect API key instead

### "Certificate limit reached"
- Remove old certificates from Apple Developer Portal
- See `CERTIFICATE_LIMIT_FIX.md` for details

### "No profiles found"
- Run `bundle exec fastlane certificates` first
- This will download certificates and provisioning profiles

## Notes

- The `env.default` file is gitignored and contains sensitive credentials
- For GitHub Actions, use GitHub Secrets instead
- Local testing uses the same Fastfile as CI/CD

