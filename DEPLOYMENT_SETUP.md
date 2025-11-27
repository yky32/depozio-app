# iOS Deployment Setup Guide

This guide explains how to set up automated deployment to TestFlight and App Store using GitHub Actions and Fastlane.

## Prerequisites

1. **Apple Developer Account** with App Store Connect access
2. **App Store Connect API Key** (recommended) or Apple ID credentials
3. **GitHub repository** with Actions enabled

## Step 1: Create App Store Connect API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com/)
2. Navigate to **Users and Access** → **Keys** → **App Store Connect API**
3. Click **Generate API Key**
4. Give it a name (e.g., "CI/CD Key")
5. Select **App Manager** or **Admin** role
6. Download the `.p8` key file (you can only download it once!)
7. Note the **Key ID** and **Issuer ID**

## Step 2: Configure GitHub Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these secrets:

### Required Secrets

- **`APP_STORE_CONNECT_API_KEY_ID`**: Your API Key ID (e.g., `ABC123DEF4`)
- **`APP_STORE_CONNECT_ISSUER_ID`**: Your Issuer ID (e.g., `12345678-1234-1234-1234-123456789012`)
- **`APP_STORE_CONNECT_API_KEY_CONTENT`**: The entire contents of your `.p8` file (copy-paste the whole file)

### Optional Secrets (for Match)

If you want to use Fastlane Match for certificate management:

- **`MATCH_GIT_URL`**: URL of a private git repository for storing certificates (e.g., `https://github.com/your-org/certificates.git`)
- **`MATCH_PASSWORD`**: Passphrase for encrypting certificates in Match

## Step 3: Set Up Fastlane Match (Optional but Recommended)

Fastlane Match manages certificates and provisioning profiles automatically. It's highly recommended for CI/CD.

### Option A: Using Match (Recommended)

1. **Create a private git repository** for certificates:
   ```bash
   # Create a new private repository on GitHub
   # Example: https://github.com/your-org/depozio-certificates.git
   ```

2. **Initialize Match locally** (run once on your Mac):
   ```bash
   cd ios
   
   # Set up App Store Connect API key
   export APP_STORE_CONNECT_API_KEY_ID="your_key_id"
   export APP_STORE_CONNECT_ISSUER_ID="your_issuer_id"
   export APP_STORE_CONNECT_API_KEY_PATH="$HOME/private_keys/AuthKey.p8"
   
   # Set a passphrase for encryption
   export MATCH_PASSWORD="your-strong-passphrase"
   
   # Set the git URL
   export MATCH_GIT_URL="https://github.com/your-org/depozio-certificates.git"
   
   # Run match
   bundle exec fastlane match appstore
   ```

3. **Add to GitHub Secrets**:
   - `MATCH_GIT_URL`: Your certificates repository URL
   - `MATCH_PASSWORD`: The passphrase you used

### Option B: Without Match (Manual)

If you don't use Match, you'll need to:
- Manually create certificates and provisioning profiles
- Store them securely
- Configure Xcode project to use them

This is more complex and not recommended for CI/CD.

## Step 4: Configure Workflow

The workflow is already configured in `.github/workflows/deploy.yml`. It will:

- **Automatically deploy to TestFlight** when you push to `main` or `develop` branches
- **Allow manual deployment** via GitHub Actions UI with choice between TestFlight or App Store

### Workflow Triggers

1. **Automatic (TestFlight)**:
   - Push to `main` or `develop` branches
   - Push tags starting with `v` (e.g., `v1.0.0`)

2. **Manual**:
   - Go to **Actions** → **Deploy to TestFlight/App Store** → **Run workflow**
   - Choose deployment type: `testflight` or `appstore`

## Step 5: Test the Deployment

1. **Make a test commit**:
   ```bash
   git checkout develop
   git commit --allow-empty -m "Test deployment"
   git push origin develop
   ```

2. **Check GitHub Actions**:
   - Go to your repository → **Actions** tab
   - Watch the workflow run
   - Check for any errors

3. **Verify in App Store Connect**:
   - Go to [App Store Connect](https://appstoreconnect.apple.com/)
   - Navigate to your app → **TestFlight**
   - You should see the new build processing

## Troubleshooting

### Build Fails with "No profiles found"

**Solution**: Set up Fastlane Match (see Step 3) or manually configure certificates.

### Build Fails with "Authentication failed"

**Solution**: 
- Verify your App Store Connect API key is correct
- Check that the key has the right permissions
- Ensure the `.p8` file content in `APP_STORE_CONNECT_API_KEY_CONTENT` is correct

### Build Succeeds but Upload Fails

**Solution**:
- Check that your app exists in App Store Connect
- Verify the bundle identifier matches (`com.depozio`)
- Ensure you have the right permissions in App Store Connect

### Match Encryption Error

**Solution**:
- Make sure `MATCH_PASSWORD` is set
- Try using App Store Connect API key instead of Apple ID
- Update Fastlane: `bundle update fastlane`

## Manual Deployment (Local)

You can also deploy manually from your Mac:

```bash
cd ios

# Set up environment
export APP_STORE_CONNECT_API_KEY_ID="your_key_id"
export APP_STORE_CONNECT_ISSUER_ID="your_issuer_id"
export APP_STORE_CONNECT_API_KEY_PATH="$HOME/private_keys/AuthKey.p8"

# Deploy to TestFlight
bundle exec fastlane beta

# Or deploy to App Store
bundle exec fastlane release
```

## Next Steps

- ✅ Set up App Store Connect API key
- ✅ Add secrets to GitHub
- ✅ (Optional) Set up Match for certificate management
- ✅ Test the deployment workflow
- ✅ Configure app metadata in App Store Connect

For more information:
- [Fastlane Documentation](https://docs.fastlane.tools/)
- [App Store Connect API](https://developer.apple.com/app-store-connect/api/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

