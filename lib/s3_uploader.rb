require 'aws-sdk-s3'

class S3Uploader
  def initialize(bucket, region)
    @bucket = bucket
    @s3 = Aws::S3::Resource.new(region: region)
  end

  def upload(file_path)
    filename = File.basename(file_path)
    obj = @s3.bucket(@bucket).object(filename)
    obj.upload_file(file_path)
  rescue StandardError => e
    raise "S3 upload failed: #{e.message}"
  end
end
