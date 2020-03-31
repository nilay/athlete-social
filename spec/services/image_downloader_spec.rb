require "rails_helper"

RSpec.describe ImageDownloader, type: :service do
  describe ".call" do
    before(:example) do
      @athlete   = create :athlete
      @post      = create :post, athlete: @athlete
      @guid      = "ABCD1234"

      stub_request(:post, "https://#{ENV["AWS_S3_BUCKET"]}.s3.amazonaws.com/?delete")
        .to_return(status: 200,
                   body: '')
      stub_request(:get, "https://#{ENV["AWS_S3_BUCKET"]}.s3.amazonaws.com/test/images/ABCD1234")
        .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'})
        .to_return(:status => 200, :body => IO.read("spec/support/fixtures/image.png"), :headers => {"Content-Type" => "image/jpg"})

      allow_any_instance_of(Paperclip::Attachment).
        to receive(:save).and_return(true)
    end

    it "attaches a file by url" do
      ImageDownloader.call(@post.id, @guid)
      expect(@guid).to include(@post.image.file_file_name)
      expect(@post.image.file_content_type).to eq("image/jpg")
    end
  end
end
