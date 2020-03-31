class SmsNotifier
  attr_accessor :phone_number, :message

  def initialize(phone_number, message)
    @phone_number = phone_number
    @message      = message
  end

  def run
    send_message!
  rescue => e
    ReportError(exception: e)
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def send_message!
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: ENV["TWILIO_SENDING_NUMBER"],
      to: "+1#{phone_number}",
      body: message
    )
  end

end
