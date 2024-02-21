require 'aws-sdk-s3'

class S3Uploader
  def initialize(bucket, region, access_key_id, secret_access_key)
    @bucket = bucket
    Aws.config.update({
                        region: region,
                        credentials: Aws::Credentials.new(access_key_id, secret_access_key)
                      })
    @s3 = Aws::S3::Resource.new
  end

  def upload(file_path)
    filename = File.basename(file_path)
    obj = @s3.bucket(@bucket).object(filename)
    obj.upload_file(file_path)
  rescue StandardError => e
    raise "S3 upload failed: #{e.message}"
  end
end
