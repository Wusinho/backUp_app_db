# frozen_string_literal: true

class AppBackup
  def initialize(app_dir, backup_dir)
    @app_dir = app_dir
    @backup_dir = backup_dir
  end

  def backup
    date = Time.now.strftime('%Y-%m-%d')
    filename = "app_backup_#{date}.tar.gz"
    filepath = "#{@backup_dir}/#{filename}"

    system("tar -czvf #{filepath} #{@app_dir}")

    raise 'Application backup failed' unless $?.success?

    filepath
  end
end
