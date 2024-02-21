class DatabaseBackup
  def initialize(db_name, db_user, db_password, db_host, backup_dir)
    @db_name = db_name
    @db_user = db_user
    @db_password = db_password
    @db_host = db_host
    @backup_dir = backup_dir
  end

  def backup
    date = Time.now.strftime('%Y-%m-%d')
    filename = "db_backup_#{date}.sql"
    filepath = "#{@backup_dir}/#{filename}"

    system("mkdir -p #{@backup_dir}")
    system("PGPASSWORD='#{@db_password}' pg_dump -h #{@db_host} -U #{@db_user} #{@db_name} > #{filepath}")

    raise "Database backup failed" unless $?.success?

    filepath
  end
end
