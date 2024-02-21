# frozen_string_literal: true

require_relative 'database_backup'
require_relative 'app_backup'
require_relative 's3_uploader'
require_relative 'cleanup'

db_name = ENV['DB_NAME']
db_user = ENV['DB_USER']
db_password = ENV['DB_PASSWORD']
db_host = ENV['DB_HOST']
app_dir = ENV['APP_DIR']
backup_dir = ENV['BACKUP_DIR']
s3_bucket = ENV['S3_BUCKET']
s3_region = ENV['S3_REGION']

begin
  db_backup = DatabaseBackup.new(db_name, db_user, db_password, db_host, backup_dir)
  app_backup = AppBackup.new(app_dir, backup_dir)
  s3_uploader = S3Uploader.new(s3_bucket, s3_region)

  db_backup_path = db_backup.backup
  app_backup_path = app_backup.backup

  s3_uploader.upload(db_backup_path)
  s3_uploader.upload(app_backup_path)

  Cleanup.run(db_backup_path, app_backup_path)

  puts 'Backup and upload completed successfully.'
rescue StandardError => e
  puts "Error: #{e.message}"
end
