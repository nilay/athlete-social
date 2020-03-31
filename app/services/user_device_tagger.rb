class UserDeviceTagger
  attr_reader :user_id, :tag

  def initialize(user_id, tag)
    @user_id = user_id
    @tag     = tag
  end

  def run
    add_tag
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def add_tag
    airship = UrbanAirship::Client.new
    named_user_tags = UrbanAirship::NamedUserTags.new(client: airship)
    named_user_ids = [user_id]
    named_user_tags.set_audience(user_ids: named_user_ids)
    named_user_tags.add(group_name: 'group_name1', tags: [tag])
    named_user_tags.send_request
  rescue => e
    ReportError.call(exception: e)
  end

  def set_audience
    if identifier_type == "named_user"
      UrbanAirship.named_user(user_id)
    elsif identifier_type == "channel_id"
      UrbanAirship.ios_channel(user_id)
    else
      UrbanAirship.push_token(user_id)
    end
  end
end
