 # GitHub Actions Workflows

## TestFlight Deployment

The `deploy.yml` workflow automatically builds and deploys your Flutter iOS app to TestFlight when:
- Code is pushed to `main` or `develop` branches
- A version tag is pushed (e.g., `v1.0.0`)
- Manually triggered via GitHub Actions UI

### Required GitHub Secrets

Configure these secrets in your GitHub repository settings (Settings → Secrets and variables → Actions):

1. **APP_STORE_CONNECT_API_KEY** (Required)
   - Your App Store Connect API key (.p8 file content)
   - Generate at: https://appstoreconnect.apple.com/access/api
   - Download the .p8 file and paste its entire content here

2. **APP_STORE_CONNECT_API_KEY_ID** (Required)
   - The Key ID from your App Store Connect API key
   - Found in App Store Connect → Users and Access → Keys

3. **APP_STORE_CONNECT_ISSUER_ID** (Required)
   - The Issuer ID from your App Store Connect account
   - Found in App Store Connect → Users and Access → Keys

4. **FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD** (Optional, for 2FA accounts)
   - App-specific password if your Apple ID has 2FA enabled
   - Generate at: https://appleid.apple.com/account/manage

5. **TEAM_ID** (Optional)
   - Your Apple Developer Team ID (e.g., `3G34999H3A`)
   - Can be found in Apple Developer Portal

### Setup Instructions

1. **Generate App Store Connect API Key:**
   - Go to https://appstoreconnect.apple.com/access/api
   - Click "Generate API Key"
   - Download the .p8 file
   - Copy the Key ID and Issuer ID

2. **Add GitHub Secrets:**
   - Go to your repository → Settings → Secrets and variables → Actions
   - Add all required secrets listed above

3. **Update Fastfile (if needed):**
   - Edit `ios/fastlane/Fastfile`
   - Update the TestFlight group name in the `beta` lane (line with `groups: ["Internal Testers"]`)

4. **Test the workflow:**
   - Push to `main` or `develop` branch, or
   - Manually trigger via Actions tab → "Build and Deploy to TestFlight" → Run workflow

### Build Process

1. Checks out code
2. Sets up Flutter and Xcode
3. Installs dependencies (CocoaPods, Flutter packages)
4. Generates localization files
5. Builds iOS app with proper code signing
6. Uploads to TestFlight
7. Build artifacts are saved if build fails

### Troubleshooting

- **Code signing errors:** Ensure your Apple Developer account has proper certificates and provisioning profiles
- **TestFlight upload fails:** Check API key permissions in App Store Connect
- **Build timeout:** Increase `timeout-minutes` in workflow file
- **Version conflicts:** Ensure version in `pubspec.yaml` is incremented

