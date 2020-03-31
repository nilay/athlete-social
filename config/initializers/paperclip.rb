require "./config/initializers/amazon_aws"

Paperclip::Attachment.default_options[:path] = ":owner_class/:style/:filename"

if AmazonAws.configured?
  Paperclip::Attachment.default_options[:storage] = :s3
  Paperclip::Attachment.default_options[:s3_credentials] = AmazonAws.config
  Paperclip::Attachment.default_options[:s3_protocol] = :https
end

Paperclip.interpolates :owner_class do |attachment, style|
  attachment.instance.avatar_owner_type
end

Paperclip.interpolates :owner_id do |attachment, style|
  attachment.instance.avatar_owner_id
end

Paperclip.interpolates :instance_guid do |attachment, style|
  attachment.instance.guid
end
