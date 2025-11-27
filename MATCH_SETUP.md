# Fastlane Match Setup Guide

Fastlane Match is the recommended solution for managing certificates and provisioning profiles in CI/CD environments. It stores them securely and syncs them using your App Store Connect API key.

## Why Match?

- ✅ Works reliably in CI/CD environments
- ✅ Uses App Store Connect API keys (no Apple ID needed)
- ✅ Stores certificates/profiles securely (git repo or cloud storage)
- ✅ Automatic sync across team members and CI/CD

## Setup Instructions

### Option 1: Git Repository (Recommended)

1. **Create a private git repository** to store certificates and profiles:
   - GitHub: Create a new private repository (e.g., `depozio-certificates`)
   - GitLab, Bitbucket, or any git hosting service works too

2. **Initialize Match locally** (run once on your Mac):
   ```bash
   cd ios
   bundle exec fastlane match appstore
   ```
   
   This will:
   - Create/download certificates and provisioning profiles
   - Encrypt and store them in your git repository
   - Install them locally

3. **Add GitHub Secret**:
   - Go to your repository → Settings → Secrets and variables → Actions
   - Add `MATCH_GIT_URL` with your git repository URL
   - Example: `https://github.com/your-org/depozio-certificates.git`
   
   If your repo requires authentication:
   - Add `MATCH_GIT_BASIC_AUTHORIZATION` with base64 encoded `username:token`
   - Or use SSH: `git@github.com:your-org/depozio-certificates.git`

### Option 2: Google Cloud Storage (Alternative)

1. **Set up Google Cloud Storage bucket**:
   ```bash
   # Create bucket
   gsutil mb gs://your-bucket-name
   ```

2. **Configure Match**:
   - Add `MATCH_GCS_BUCKET_NAME` secret with your bucket name
   - Add Google Cloud credentials if needed

3. **Initialize Match**:
   ```bash
   cd ios
   bundle exec fastlane match appstore --storage_mode="gcs"
   ```

## Current Setup

The workflow is configured to use Match if `MATCH_GIT_URL` is set. If not set, it will attempt automatic signing (which may fail in CI/CD).

## Troubleshooting

- **"Match sync failed"**: This is normal if Match hasn't been initialized yet. Run `fastlane match appstore` locally first.
- **"No certificates found"**: Initialize Match locally to create and store certificates.
- **Authentication errors**: Ensure your git repository is accessible and credentials are correct.

## Next Steps

1. Create a private git repository for certificates
2. Run `fastlane match appstore` locally to initialize
3. Add `MATCH_GIT_URL` to GitHub Secrets
4. The workflow will automatically sync certificates/profiles on each run

For more information: https://docs.fastlane.tools/actions/match/

