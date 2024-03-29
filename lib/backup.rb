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
s3_access_key_id = ENV['AWS_ACCESS_KEY_ID']
s3_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
backup_destination = ENV['INPUT_BACKUP_DESTINATION'].downcase

begin
  db_backup_path = DatabaseBackup.new(db_name, db_user, db_password, db_host, backup_dir).backup
  app_backup_path = AppBackup.new(app_dir, backup_dir).backup

  case backup_destination
  when 's3'
    raise ArgumentError, 'S3 bucket and region must be provided for S3 backup' if s3_bucket.empty? || s3_region.empty?

    s3_uploader = S3Uploader.new(s3_bucket, s3_region, s3_access_key_id, s3_secret_access_key)
    s3_uploader.upload(db_backup_path)
    s3_uploader.upload(app_backup_path)

    Cleanup.run(db_backup_path, app_backup_path)
  when 'local'
    puts "Backups saved locally in #{backup_dir}"
  else
    raise ArgumentError, 'Invalid backup destination. Use "s3" or "local".'
  end

  puts 'Backup and upload completed successfully.'
rescue StandardError => e
  puts "Error during backup process: #{e.message}"
end
