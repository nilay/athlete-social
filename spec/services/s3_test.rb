require 'test_helper'

class S3Test < ActiveSupport::TestCase

  setup do
    @filename = SecureRandom.random_number(1000)
    @data     = load_test_file("services/s3/picture.png")
  end

  test "Save" do
    assert S3.resource(:cloud_files).save @filename, @data
    file = S3.resource(:cloud_files).get @filename
    assert_match "https://protein-api.s3.amazonaws.com/test/cloud_files/#{@filename}", file.public_url
    assert S3.resource(:cloud_files).delete @filename
  end

  test "Delete" do
    assert S3.resource(:cloud_files).save @filename, @data
    file = S3.resource(:cloud_files).get @filename
    assert_match "https://protein-api.s3.amazonaws.com/test/cloud_files/#{@filename}", file.public_url
    assert S3.resource(:cloud_files).delete @filename
    file = S3.resource(:cloud_files).get @filename
    assert !file.exists?
  end

  test "Public URL" do
    assert S3.resource(:cloud_files).save @filename, @data
    file = S3.resource(:cloud_files).get @filename
    url = S3.resource(:cloud_files).public_url_for(@filename)
    assert_match "s3.amazonaws.com/test/cloud_files/#{@filename}", url
    assert S3.resource(:cloud_files).delete @filename
  end

  test "Expiring URL" do
    assert S3.resource(:cloud_files).save @filename, @data
    file = S3.resource(:cloud_files).get @filename
    url = S3.resource(:cloud_files).expiring_url_for(@filename)
    assert_match "s3.amazonaws.com/test/cloud_files/#{@filename}", url
    assert_match "X-Amz-Algorithm", url
    assert_match "X-Amz-Credential", url
    assert_match "X-Amz-Date", url
    assert_match "X-Amz-Expires", url
    assert_match "X-Amz-SignedHeaders", url
    assert_match "X-Amz-Signature", url
    assert S3.resource(:cloud_files).delete @filename
  end

  test "Presigned upload URL" do
    url = S3.resource(:cloud_files).upload_url_for @filename, "image/png"
    assert_match "s3.amazonaws.com/test/cloud_files/#{@filename}", url
    assert_match "X-Amz-Algorithm", url
    assert_match "X-Amz-Credential", url
    assert_match "X-Amz-Date", url
    assert_match "X-Amz-Expires", url
    assert_match "X-Amz-SignedHeaders", url
    assert_match "x-amz-acl", url
    assert_match "X-Amz-Signature", url
  end

end
