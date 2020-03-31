class PushNotifier
  attr_reader :deep_link, :user_ids, :message, :identifier_type, :device_types, :confirm_existence

  def initialize(user_ids, message, deep_link = nil, identifier_type = "named_user", device_types = ["ios"], confirm_existence = false)
    @user_ids           = user_ids
    @message            = message
    @identifier_type    = identifier_type
    @deep_link          = deep_link
    @device_types       = device_types
    @confirm_existence  = confirm_existence
  end

  def run
    # allows us to pass in a global id string, and verify it's existence before sending a push
    # if defaulted to false, will just be nil, and send_notification anyway
    GlobalID::Locator.locate confirm_existence
    send_notification
  rescue ActiveRecord::RecordNotFound
    return
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def archive_result(result, push)
    PushNotification.create do |p|
      p.status  = result.ok ? :successful : :failed
      p.message = message
      p.details = push.payload
      p.result  = result.payload
    end
  end

  def build_push
    airship           = UrbanAirship::Client.new
    push              = airship.create_push
    push.audience     = set_audience
    push.notification = set_payload
    push.device_types = set_device_types
    push
  end

  def send_notification
    push = build_push
    result = push.send_push
    archive_result(result, push)
  rescue => e
    ReportError.call(exception: e)
  end


  def set_audience
    if identifier_type == "named_user"
      UrbanAirship.named_user(user_ids)
    elsif identifier_type == "channel_id"
      UrbanAirship.ios_channel(user_ids)
    else
      UrbanAirship.push_token(user_ids)
    end
  end

  def set_device_types
    UrbanAirship.device_types(device_types)
  end

  def set_payload
    payload = {
      alert: message,
      ios: {
        "sound": "default",
        "badge": "+1"
      }
    }
    if deep_link
      payload.merge!( { actions: {
        open: {
          type: "deep_link",
          content: deep_link
        }
      }
      })
    end
    UrbanAirship.notification(payload)
  end
end
