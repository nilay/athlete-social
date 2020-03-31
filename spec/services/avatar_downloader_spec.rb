require "rails_helper"

RSpec.describe AvatarDownloader, type: :service do
  describe ".call" do
    before(:example) do
      @athlete = create :athlete
      @guid = "ABCD1234"

      stub_request(:get, "https://#{ENV["AWS_S3_BUCKET"]}.s3.amazonaws.com/test/avatars/ABCD1234")
         .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'})
         .to_return(status: 200,
                    body: File.read("spec/support/fixtures/image.jpg"),
                    headers: { "Content-Type" => "image/jpg" })

      allow_any_instance_of(Paperclip::Attachment).
        to receive(:save).and_return(true)
    end

    it "attaches a file by url" do
      AvatarDownloader.call(@athlete.avatar.id, @guid)
      expect(@athlete.avatar.file_content_type).to eq("image/jpg")
    end
  end
end
