# Certificate Management Guide

## Problem: Maximum Certificate Limit Reached

Apple limits the number of Distribution certificates you can have. When you reach this limit, you'll see:
```
Could not create another Distribution certificate, reached the maximum number of available Distribution certificates.
```

## Solution 1: Use Existing Certificates (Recommended)

The Fastfile has been updated to use `readonly: true` in the `cert` action. This means:
- ✅ Fastlane will download and use existing certificates
- ✅ It won't try to create new ones
- ✅ Prevents hitting the certificate limit

## Solution 2: Remove Old Certificates

If you need to create a new certificate, you must first remove old/unused ones.

### Method 1: Via Apple Developer Portal (Web)

1. **Go to Apple Developer Portal**
   - Visit: https://developer.apple.com/account/resources/certificates/list
   - Sign in with your Apple ID

2. **View Certificates**
   - Click on "Certificates, Identifiers & Profiles"
   - Select "Certificates" from the left sidebar
   - Filter by "Production" to see Distribution certificates

3. **Identify Old Certificates**
   - Look for certificates that are:
     - Expired (red status)
     - Not being used by any apps
     - From old projects you no longer maintain

4. **Revoke Certificates**
   - Click on a certificate you want to remove
   - Click "Revoke" button
   - Confirm the revocation
   - ⚠️ **Warning**: Revoking a certificate will invalidate any apps signed with it!

### Method 2: Via Fastlane (Command Line)

You can use Fastlane to list and manage certificates:

```bash
cd ios

# List all certificates
bundle exec fastlane run get_certificates

# Note: Fastlane doesn't have a direct "revoke" command
# You'll need to use the web portal to revoke certificates
```

### Method 3: Via Xcode

1. Open Xcode
2. Go to **Xcode → Settings → Accounts**
3. Select your Apple ID
4. Click "Manage Certificates..."
5. Right-click on old certificates and select "Delete"
6. Confirm deletion

## Best Practices

1. **Use `readonly: true`** in CI/CD to avoid creating unnecessary certificates
2. **Regularly clean up** expired or unused certificates
3. **Keep at least one valid certificate** for each app you're actively developing
4. **Document certificate usage** so you know which ones are safe to remove

## Current Fastfile Configuration

The `certificates` lane now uses:
```ruby
cert(
  team_id: "3G34999H3A",
  readonly: true  # Downloads existing certificates instead of creating new ones
)
```

This ensures that:
- Existing certificates are downloaded and used
- No new certificates are created unless absolutely necessary
- You won't hit the certificate limit

## If You Still Need a New Certificate

If you absolutely need a new certificate (e.g., old ones are all expired):

1. **Remove old certificates** using one of the methods above
2. **Temporarily remove `readonly: true`** from the Fastfile
3. **Run the workflow** to create a new certificate
4. **Add `readonly: true` back** to prevent future issues

## Checking Certificate Status

To see your current certificates:

1. Visit: https://developer.apple.com/account/resources/certificates/list
2. Filter by "Production" to see Distribution certificates
3. Check the status and expiration dates
4. Identify which ones you can safely remove

## Important Notes

- ⚠️ **Revoking a certificate invalidates all apps signed with it**
- ⚠️ **You cannot revoke a certificate that's currently being used by an app in App Store Connect**
- ✅ **Expired certificates can be safely removed** (they're already invalid)
- ✅ **Certificates from old/unused projects are safe to remove**

