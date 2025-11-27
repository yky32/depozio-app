# App Store Connect API Key Setup Guide

## Why Use API Key?

Apple blocks automated access using Apple ID credentials in CI/CD environments (like GitHub Actions) for security reasons. This causes "Access forbidden" errors.

**Solution**: Use App Store Connect API Key, which is specifically designed for CI/CD and doesn't have these restrictions.

## How to Create API Key

1. **Go to App Store Connect**
   - Visit: https://appstoreconnect.apple.com
   - Sign in with your Apple ID

2. **Navigate to Users and Access**
   - Click on your name (top right)
   - Select "Users and Access"
   - Go to "Keys" tab

3. **Generate New Key**
   - Click the "+" button
   - Enter a name (e.g., "GitHub Actions CI/CD")
   - Select "App Manager" or "Admin" role
   - Click "Generate"

4. **Download the Key**
   - ⚠️ **IMPORTANT**: Download the `.p8` file immediately
   - You can only download it once!
   - Save it securely (e.g., `AuthKey_XXXXXXXXXX.p8`)

5. **Note the Details**
   - **Key ID**: Shown in the key name (e.g., `AuthKey_XXXXXXXXXX.p8` → `XXXXXXXXXX`)
   - **Issuer ID**: Found at the top of the Keys page

## Add to GitHub Secrets

Go to: `https://github.com/yky32/depozio-app/settings/secrets/actions`

Add these secrets:

1. **APP_STORE_CONNECT_API_KEY_ID**
   - Value: The Key ID (e.g., `XXXXXXXXXX`)

2. **APP_STORE_CONNECT_ISSUER_ID**
   - Value: Your Issuer ID (found on Keys page)

3. **APP_STORE_CONNECT_API_KEY_CONTENT**
   - Value: The entire contents of the `.p8` file
   - Copy the whole file content (including `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`)

## Verify Setup

After adding the secrets, the workflow will:
1. Create the API key file automatically
2. Use it for `cert` and `sigh` actions
3. Use it for `upload_to_app_store` action

## Fallback

If API key is not configured, the workflow will fall back to Apple ID authentication (but this may fail with "Access forbidden" in CI/CD).

## Security Notes

- Never commit the `.p8` file to Git
- The file is created temporarily in GitHub Actions
- Store the `.p8` file securely (e.g., password manager)
- You can revoke keys in App Store Connect if compromised

