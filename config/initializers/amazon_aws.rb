module AmazonAws
  module_function

  def config
    {
      bucket: bucket,
      access_key_id: access_key_id,
      secret_access_key: secret_access_key,
      s3_region: s3_region
    }
  end

  def configured?
    !!(bucket && access_key_id && secret_access_key)
  end

  def s3_region
    ENV["AWS_REGION"].presence
  end

  def bucket
    ENV["AWS_S3_BUCKET"].presence
  end

  def access_key_id
    ENV["AWS_ACCESS_KEY_ID"].presence
  end

  def secret_access_key
    ENV["AWS_SECRET_ACCESS_KEY"]
  end
end
