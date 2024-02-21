# frozen_string_literal: true
class Cleanup
  def self.run(*files)
    files.each { |file| File.delete(file) if File.exist?(file) }
  rescue StandardError => e
    raise "Cleanup failed: #{e.message}"
  end
end
