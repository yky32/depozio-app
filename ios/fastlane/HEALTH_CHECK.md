# Fastlane Health Check Report

## Configuration Files Status

### ✅ Fastfile
- **Status**: Clean and simplified
- **Lanes**:
  - `check_env` - Debug environment variables
  - `certificates` - Download certificates and provisioning profiles
  - `build` - Build and export IPA
  - `upload` - Upload to App Store Connect
  - `deploy` - Build + Upload
- **Syntax**: Valid ✓

### ✅ Appfile
- **App Identifier**: `com.depozio` ✓
- **Apple ID**: Uses `FASTLANE_USER` from environment ✓
- **Team ID**: `3G34999H3A` ✓

### ✅ Gemfile
- **Fastlane**: Included ✓
- **CocoaPods**: Included ✓

## GitHub Secrets Required

### For Code Signing (Required)
- ✅ `FASTLANE_USER` - Your Apple ID email
- ✅ `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` - App-specific password

### For Upload (Optional - if using API key)
- `APP_STORE_CONNECT_API_KEY_ID` - API Key ID
- `APP_STORE_CONNECT_ISSUER_ID` - Issuer ID
- `APP_STORE_CONNECT_API_KEY_CONTENT` - Contents of .p8 file

## Environment Variables Flow

### Setup Code Signing Step
- Sets: `FASTLANE_USER`, `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`
- Unsets: `APP_STORE_CONNECT_API_KEY_PATH` (to force username/password)

### Build iOS App Step
- Sets: `FASTLANE_USER`, `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`
- Sets: `APP_STORE_CONNECT_API_KEY_*` (if available)
- Sets: `VERSION`, `BUILD_NUMBER`

### Deploy to App Store Step
- Sets: All authentication variables for upload

## How to Test

### 1. Check Environment Variables
```bash
cd ios
bundle exec fastlane check_env
```

### 2. Test Certificates Download
```bash
cd ios
export FASTLANE_USER="wayneyu.dev@gmail.com"
export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD="your-password"
bundle exec fastlane certificates
```

### 3. Verify GitHub Secrets
Go to: `https://github.com/yky32/depozio-app/settings/secrets/actions`

Required secrets:
- `FASTLANE_USER` = `wayneyu.dev@gmail.com`
- `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` = Your app-specific password

## Common Issues

1. **"Invalid username and password"**
   - Verify app-specific password is correct
   - Generate new password at https://appleid.apple.com

2. **"No profiles found"**
   - Certificates step must run before build
   - Check that `certificates` lane completed successfully

3. **"Missing password"**
   - Ensure `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` is set in GitHub secrets
   - Check workflow logs for "Environment Variables Check"

## Verification Checklist

- [ ] Fastfile syntax is valid
- [ ] Appfile has correct bundle ID and team ID
- [ ] Gemfile includes fastlane
- [ ] GitHub secrets are set:
  - [ ] FASTLANE_USER
  - [ ] FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD
- [ ] Workflow passes environment variables correctly
- [ ] env.default file exists (for local testing, gitignored)

