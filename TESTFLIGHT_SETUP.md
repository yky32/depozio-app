# TestFlight Deployment Setup Guide

This guide will help you set up automated TestFlight deployments using GitHub Actions and Fastlane.

## Prerequisites

1. An Apple Developer account with App Store Connect access
2. Your app registered in App Store Connect
3. GitHub repository with Actions enabled

## Step 1: Generate App Store Connect API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** → **Keys** → **App Store Connect API**
3. Click **Generate API Key**
4. Enter a name (e.g., "GitHub Actions CI/CD")
5. Select **App Manager** or **Admin** role
6. Click **Generate**
7. **Download the .p8 key file** (you can only download it once!)
8. Note down:
   - **Key ID** (e.g., `ABC123DEF4`)
   - **Issuer ID** (e.g., `12345678-1234-1234-1234-123456789012`)

## Step 2: Configure GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** and add the following:

### Required Secrets

| Secret Name | Description | How to Get |
|------------|-------------|------------|
| `APP_STORE_CONNECT_API_KEY` | Content of the .p8 file | Open the downloaded .p8 file in a text editor and copy the entire content (including `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`) |
| `APP_STORE_CONNECT_API_KEY_ID` | Key ID from App Store Connect | From Step 1, the Key ID you noted down |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID from App Store Connect | From Step 1, the Issuer ID you noted down |

### Optional Secrets

| Secret Name | Description | When Needed |
|------------|-------------|-------------|
| `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD` | App-specific password | Only if your Apple ID has 2FA enabled and you're using it for authentication |
| `TEAM_ID` | Apple Developer Team ID | If you want to override the default team ID (found in `ios/fastlane/Appfile`) |

## Step 3: Update Fastlane Configuration

1. Edit `ios/fastlane/Fastfile`
2. Update the TestFlight group name (line ~40):
   ```ruby
   groups: ["Internal Testers"]  # Change to your actual TestFlight group name
   ```
3. If needed, update the bundle identifier in `ios/fastlane/Appfile`:
   ```ruby
   app_identifier("com.depozio")  # Should match your app's bundle ID
   ```

## Step 4: Test the Workflow

### Option 1: Manual Trigger

1. Go to your GitHub repository → **Actions** tab
2. Select **Build and Deploy to TestFlight** workflow
3. Click **Run workflow**
4. Select branch and optionally provide a build number
5. Click **Run workflow**

### Option 2: Push to Main/Develop

1. Make a commit and push to `main` or `develop` branch:
   ```bash
   git add .
   git commit -m "Test TestFlight deployment"
   git push origin main
   ```
2. The workflow will automatically trigger

### Option 3: Create a Version Tag

1. Create and push a version tag:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```
2. The workflow will automatically trigger

## Step 5: Verify Deployment

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **My Apps** → **Depozio** → **TestFlight**
3. Check the **iOS Builds** section
4. Your build should appear within a few minutes

## Troubleshooting

### Build Fails with Code Signing Error

**Solution:** Ensure your App Store Connect API key has the correct permissions:
- Go to App Store Connect → Users and Access → Keys
- Verify the key has **App Manager** or **Admin** role
- Ensure the key is not expired

### TestFlight Upload Fails

**Solution:** Check the following:
1. Verify all GitHub secrets are set correctly
2. Check the workflow logs for specific error messages
3. Ensure your app is registered in App Store Connect
4. Verify the bundle identifier matches (`com.depozio`)

### "No matching provisioning profiles found"

**Solution:** 
- The workflow uses automatic code signing
- Ensure your Apple Developer account has proper certificates
- Check that your Team ID is correct in `ios/fastlane/Appfile`

### Build Timeout

**Solution:**
- Increase `timeout-minutes` in `.github/workflows/deploy.yml` (currently 60 minutes)
- Check if dependencies are taking too long to download

## Workflow Details

The workflow performs the following steps:

1. ✅ Checks out your code
2. ✅ Sets up Flutter (version 3.38.3)
3. ✅ Sets up Xcode (version 16.4)
4. ✅ Installs CocoaPods dependencies
5. ✅ Gets Flutter packages
6. ✅ Generates localization files
7. ✅ Builds the iOS app
8. ✅ Uploads to TestFlight
9. ✅ Saves build artifacts if build fails

## Manual Fastlane Commands

You can also run Fastlane commands locally:

```bash
cd ios

# Install dependencies
bundle install

# Build only (no upload)
bundle exec fastlane build

# Build and upload to TestFlight
bundle exec fastlane beta

# Upload existing build
bundle exec fastlane upload
```

## Additional Resources

- [Fastlane Documentation](https://docs.fastlane.tools)
- [App Store Connect API Documentation](https://developer.apple.com/documentation/appstoreconnectapi)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## Support

If you encounter issues:
1. Check the GitHub Actions logs for detailed error messages
2. Review the Fastlane documentation
3. Verify all secrets are correctly configured
4. Ensure your Apple Developer account has proper access

