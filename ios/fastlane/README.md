# Fastlane Setup for iOS Deployment

This directory contains the fastlane configuration for deploying the Depozio app to the App Store.

## Prerequisites

1. **App Store Connect API Key** (Recommended method)
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Navigate to Users and Access → Keys
   - Create a new API key with App Manager or Admin role
   - Download the `.p8` key file
   - Note the Key ID and Issuer ID

2. **Apple ID Account** (Alternative method)
   - Your Apple ID email address
   - App-specific password (if using 2FA)

## GitHub Secrets Setup

Add the following secrets to your GitHub repository (Settings → Secrets and variables → Actions):

### Option 1: Using App Store Connect API Key (Recommended)

- `APP_STORE_CONNECT_API_KEY_ID`: Your App Store Connect API Key ID
- `APP_STORE_CONNECT_ISSUER_ID`: Your App Store Connect Issuer ID  
- `APP_STORE_CONNECT_API_KEY_CONTENT`: The contents of your `.p8` key file (or base64 encoded)

### Option 2: Using Apple ID (Alternative)

- `FASTLANE_USER`: Your Apple ID email address
- `FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD`: App-specific password (if 2FA enabled)

## Usage

### Manual Deployment via GitHub Actions

1. Go to Actions tab in your GitHub repository
2. Select "Deploy iOS to App Store" workflow
3. Click "Run workflow"
4. Optionally specify version and build number
5. Click "Run workflow" button

### Automatic Deployment

The workflow will automatically run when:
- Pushing to `main` or `master` branch
- Creating a tag starting with `v` (e.g., `v1.0.0`)

## Fastlane Lanes

- `deploy_app_store`: Uploads the app to App Store Connect (does not submit for review)
- `deploy_and_submit`: Uploads and submits the app for review

## Local Testing

To test fastlane locally:

```bash
cd ios
bundle install
bundle exec fastlane deploy_app_store
```

## Troubleshooting

### Build Errors
- Ensure Flutter is properly installed
- Check that all dependencies are up to date (`flutter pub get`)
- Verify CocoaPods are installed (`pod install`)

### Authentication Errors
- Verify all GitHub secrets are correctly set
- Check that your API key has the correct permissions
- Ensure the bundle identifier matches your App Store Connect app

### Upload Errors
- Verify the app exists in App Store Connect
- Check that the version number is higher than the previous release
- Ensure the build number is unique

