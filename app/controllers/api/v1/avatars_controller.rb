class Api::V1::AvatarsController < Api::V1::ApplicationController
  skip_before_action :check_request_format
  skip_before_action :api_authentication_required

  def new
    @guid = SecureRandom.hex(16)
    @url =  Avatar.upload_url(@guid)
  end

end
