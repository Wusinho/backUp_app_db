# Reusable Backup Action

This GitHub Action automates the process of backing up your application's database and files, then uploading them to AWS S3. It's designed to be flexible and reusable across different projects.

### Features
Database backup (currently supports PostgreSQL).
Application directory backup.
Upload backups to AWS S3.
Clean up local backup files after upload.

### Prerequisites
AWS S3 Bucket: Ensure you have an S3 bucket where the backups will be stored.
AWS Credentials: Required for uploading files to your S3 bucket.

## Usage

#### Step 1: Configure GitHub Secrets
Configure the following secrets in your GitHub repository to securely store sensitive information:

- AWS_ACCESS_KEY_ID: Your AWS access key.
- AWS_SECRET_ACCESS_KEY: Your AWS secret access key.
- DB_NAME: The name of your database.
- DB_USER: The database user.
- DB_PASSWORD: The database password.
- DB_HOST: The host address of your database.
- S3_BUCKET: The name of your AWS S3 bucket.

#### Step 2: Add the Action to Your Workflow
Create a workflow file (if you haven't already) in your repository under .github/workflows, for example, .github/workflows/backup.yml, and add the following configuration:

```yaml
name: Backup Workflow

on:
  workflow_dispatch: # Allows manual trigger
  schedule:
    - cron: '0 2 * * *' # Adjust to your preferred schedule

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Run Backup
        uses: Wusinho/reusable-backup-action@main
        with:
          db_name: ${{ secrets.DB_NAME }}
          db_user: ${{ secrets.DB_USER }}
          db_password: ${{ secrets.DB_PASSWORD }}
          db_host: ${{ secrets.DB_HOST }}
          app_dir: './path/to/your/app' # Adjust as necessary
          backup_dir: '/tmp/backup' # Temporary local directory for backup files
          s3_bucket: ${{ secrets.S3_BUCKET }}
          s3_region: ${{ secrets.S3_REGION }}
```