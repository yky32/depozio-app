# Certificate Limit Fix Guide

## Problem

You're hitting Apple's certificate limit:
```
Could not create another Distribution certificate, reached the maximum number of available Distribution certificates.
```

## Solution: Remove Old Certificates

### Step 1: List Your Certificates

**Option A: Via Fastlane (Recommended)**
```bash
cd ios
bundle exec fastlane list_certificates
```

**Option B: Via Apple Developer Portal**
1. Go to: https://developer.apple.com/account/resources/certificates/list
2. Sign in with your Apple ID
3. Filter by "Production" to see Distribution certificates

### Step 2: Identify Certificates to Remove

Look for certificates that are:
- ✅ **Expired** (red status, past expiration date)
- ✅ **From old/unused projects** (you no longer maintain)
- ✅ **Not being used** by any active apps
- ❌ **DO NOT remove** certificates that are:
  - Currently in use by apps in App Store Connect
  - Recently created and still valid
  - Being used by your team

### Step 3: Remove Certificates

**Via Apple Developer Portal:**
1. Go to: https://developer.apple.com/account/resources/certificates/list
2. Click on a certificate you want to remove
3. Click **"Revoke"** button
4. Confirm the revocation
5. ⚠️ **Warning**: Revoking a certificate will invalidate any apps signed with it!

**Via Xcode:**
1. Open Xcode
2. Go to **Xcode → Settings → Accounts**
3. Select your Apple ID
4. Click **"Manage Certificates..."**
5. Right-click on old certificates → **Delete**

### Step 4: Verify Removal

After removing certificates, verify:
```bash
cd ios
bundle exec fastlane list_certificates
```

Or check the portal: https://developer.apple.com/account/resources/certificates/list

## How the Fastfile Now Works

The updated Fastfile will:

1. **Always check for existing certificates first** using `get_certificates` with `readonly: true`
2. **Download and reuse existing certificates** if they exist
3. **Only create new certificates** if none exist in Apple Developer Portal
4. **Show clear warnings** before creating new certificates
5. **Provide helpful error messages** if the limit is reached

## Best Practices

1. **Regularly clean up** expired or unused certificates (monthly)
2. **Keep at least one valid certificate** for each app you're actively developing
3. **Document certificate usage** so you know which ones are safe to remove
4. **Use `readonly: true`** in CI/CD to avoid creating unnecessary certificates

## Current Fastfile Behavior

```ruby
# 1. Try to get existing certificates (readonly)
get_certificates(team_id: "3G34999H3A", readonly: true)

# 2. If found → use them (skip cert creation)
# 3. If not found → create new one (with warnings)
# 4. If limit reached → show helpful error with link to portal
```

## Quick Reference

- **List certificates**: `bundle exec fastlane list_certificates`
- **Remove certificates**: https://developer.apple.com/account/resources/certificates/list
- **Check limit**: Apple allows a limited number of active certificates per account

## Need Help?

If you're still hitting the limit after removing old certificates:
1. Check if you have multiple Apple Developer accounts
2. Verify you're removing certificates from the correct team (Team ID: 3G34999H3A)
3. Wait a few minutes after revoking - it may take time to propagate
4. Contact Apple Developer Support if the limit seems incorrect

