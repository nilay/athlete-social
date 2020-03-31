class S3
  include Singleton
  attr_accessor :bucket, :resource
  # Usage: Protein::S3.resource(:pulse_icons).[instance method]
  # Returns: A shared instance of Protein::S3 with the correct S3 bucket to use.
  def self.resource(resource)
    instance.resource = resource
    instance
  end

  # Saves `data` to file for `identifier`
  # Usage: Protein::S3.resource(:email_errors).save(3245, data)
  # return: true/false depending on successful save
  def save(identifier, data)
    bucket.put_object(key: key(identifier), body: data, acl: "public-read")
  end

  # Gets the S3 object for `identifier`
  # Usage: Protein::S3.resource(:sound_files).get(234)
  # return: file
  def get(identifier)
    bucket.object(key(identifier))
  end

  # Deletes the file for `identifier`
  # Usage: Protein::S3.resource(:sound_files).delete(324)
  # Returns: true/false depending on successful deletion
  def delete(identifier)
    bucket.delete_objects(delete: { objects: [{ key: key(identifier) }] }).successful?
  end

  # Create a URL that never expires.
  # Usage: Protein::S3.resource(:sound_files).public_url_for(3233)
  # Returns: url/nil depending on successful request
  def public_url_for(identifier)
    get(identifier).public_url
  end

  # Create a URL that expires after a time, default is 30 minutes.
  # Usage: Protein::S3.resource(:sound_files).expiring_url_for(3233, 30.minutes)
  # Returns: url/nil depending on successful request
  def expiring_url_for(identifier, expiry = 1800)
    get(identifier).presigned_url(:get, expires_in: expiry)
  end

  # Returns a URL for uploading a sound file for `identifier`
  # Usage: Protein::S3.resource(:sound_files).upload_url(235)
  # Returns: A URL you then can use to upload the file directly to S3 from the bucket.
  def upload_url_for(identifier, content_type)
    get(identifier).presigned_url :put, key: key(identifier), acl: "public-read", content_type: content_type
  end

  private

  def bucket
    @bucket ||= Aws::S3::Bucket.new(name: ENV["AWS_S3_BUCKET"])
  end

  def key(identifier)
    File.join Rails.env.to_s, @resource.to_s, identifier.to_s
  end
end
