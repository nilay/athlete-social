require "rails_helper"

RSpec.describe PushNotifier, type: :service do
  describe ".call" do
    before(:example) do
      @notifier = double("notifier")
    end

    context "without deep links" do
      it "should send a notification with deep links" do
        stub_request(:post, "https://xwIt3f0ZQCqrPDDSjCplYg:QaEtD0pLS0uk2FDpsr7V-Q@go.urbanairship.com/api/push/").
           with(:body => "{\"audience\":{\"named_user\":\"global_id_1\"},\"notification\":{\"alert\":\"Test Message\",\"actions\":{\"open\":{\"type\":\"deep_link\",\"content\":\"pros://athletes/5\"}},\"ios\":{\"sound\":\"default\"}},\"device_types\":[\"ios\"]}",
                :headers => {'Accept'=>'application/vnd.urbanairship+json; version=3', 'Accept-Encoding'=>'gzip', 'Content-Length'=>'200', 'Content-Type'=>'application/json', 'User-Agent'=>'unirest-ruby/1.1'}).
           to_return(:status => 200, :body => "", :headers => {})
        expect(PushNotifier).to receive(:new).with(["global_id_1"], "Test Message", "pros://athletes/5").and_return(@notifier)
        expect(@notifier).to receive(:run)
        PushNotifier.call(["global_id_1"],
                          "Test Message",
                          "pros://athletes/5")
      end
    end

    context "without deep links" do
      it "should send a notification" do
        stub_request(:post, "https://xwIt3f0ZQCqrPDDSjCplYg:QaEtD0pLS0uk2FDpsr7V-Q@go.urbanairship.com/api/push/").
           with(:body => "{\"audience\":{\"named_user\":\"global_id_1\"},\"notification\":{\"alert\":\"Test Message\",\"ios\":{\"sound\":\"default\"}},\"device_types\":[\"ios\"]}",
                :headers => {'Accept'=>'application/vnd.urbanairship+json; version=3', 'Accept-Encoding'=>'gzip', 'Content-Length'=>'130', 'Content-Type'=>'application/json', 'User-Agent'=>'unirest-ruby/1.1'}).
           to_return(:status => 200, :body => "", :headers => {})
        expect(PushNotifier).to receive(:new).with(["global_id_1"], "Test Message").and_return(@notifier)
        expect(@notifier).to receive(:run)
        PushNotifier.call(["global_id_1"],
                          "Test Message")
      end
    end

    context "with a global id sent in and the object still exists" do
      let(:comment) { create(:comment) }
      let(:arguments) do
        [
          ["global_id_1"],
          "Test Message",
          nil,
          "named_user",
          ["ios"],
          "gid://Pros/Comment/#{comment.id}",
        ]
      end

      let(:notifier) { PushNotifier.new(*arguments) }

      it "should send the notification" do
        expect(notifier).to receive(:send_notification)

        notifier.run
      end
    end

    context "with a global id and the object DOES NOT exist" do
      let(:comment) { create(:comment) }
      let(:arguments) do
        [
          ["global_id_1"],
          "Test Message",
          nil,
          "named_user",
          ["ios"],
          "gid://Pros/Comment/#{comment.id}",
        ]
      end

      let(:notifier) { PushNotifier.new(*arguments) }

      it "should send the notification" do
        comment.destroy
        expect(notifier).not_to receive(:send_notification)

        notifier.run
      end
    end
  end

  describe "#send_notification" do
    before(:example) do
      @notifier = PushNotifier.new(["id_1"], "Test Message")
      @client = double("client")
      @push = double("push")
      @user = double("user")
      @notification = double("notification")
      @device_type = double("device type")
    end

    it "sends a notification" do
      allow(UrbanAirship).to receive(:named_user).and_return(@user)
      allow(UrbanAirship).to receive(:device_types).and_return(@device_type)
      expect(UrbanAirship::Client).to receive(:new).and_return(@client)
      expect(UrbanAirship).to receive(:notification).with({:alert=>"Test Message", :ios=>{:sound=>"default", :badge=>"+1"}}).and_return(@notification)
      expect(@client).to receive(:create_push).and_return(@push)
      expect(@push).to receive(:notification=).with(@notification)
      expect(@push).to receive(:audience=).with(@user)
      expect(@push).to receive(:device_types=).with(@device_type)
      expect(@push).to receive(:send_push)
      @notifier.send(:send_notification)
    end

  end

  describe "#set_payload" do
    it "sets payload with a deep link" do
      notifier = PushNotifier.new(["id_1"], "Test Message", "pros://athletes/5")
      payload = notifier.send(:set_payload)
      expect(payload).to eq({:alert=>"Test Message", :ios=>{:sound=>"default", :badge=>"+1"}, :actions=>{:open=>{:type=>"deep_link", :content=>"pros://athletes/5"}}})
    end

    it "sets payload without a deep link" do
      notifier = PushNotifier.new(["id_1"], "Test Message")
      payload = notifier.send(:set_payload)
      expect(payload).to eq({:alert=>"Test Message", :ios=>{:sound=>"default", :badge=>"+1"}})
    end
  end

  describe "#archive_result" do
    it "archives the push notication with a successful result" do
      result = double("result", ok: true)
      push   = double("push")
      result_hash = { "test_result" => true, "ok" => true }
      push_hash   = { "test_push" => true, "audience" => { "named_user" => "id_1" } }
      expect(result).to receive(:payload).and_return(result_hash).at_least(2).times
      expect(push).to receive(:payload).and_return(push_hash).at_least(2).times
      notifier = PushNotifier.new(["id_1"], "Test Message")
      archive = notifier.send(:archive_result, result, push)
      expect(archive).to be_a PushNotification
      expect(archive.result).to eq(result.payload)
      expect(archive.details).to eq(push.payload)
      expect(archive.status).to eq("successful")
      expect(archive.persisted?).to be true
    end

    it "archives the push notication with a failed result" do
      result = double("result", ok: false)
      push   = double("push")
      result_hash = { "test_result" => true, "ok" => true }
      push_hash   = { "test_push" => true, "audience" => { "named_user" => "id_1" } }
      expect(result).to receive(:payload).and_return(result_hash).at_least(2).times
      expect(push).to receive(:payload).and_return(push_hash).at_least(2).times
      notifier = PushNotifier.new(["id_1"], "Test Message")
      archive = notifier.send(:archive_result, result, push)
      expect(archive).to be_a PushNotification
      expect(archive.result).to eq(result.payload)
      expect(archive.details).to eq(push.payload)
      expect(archive.status).to eq("failed")
      expect(archive.persisted?).to be true
    end
  end
end
