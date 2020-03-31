class Api::V1::ApplicationController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_request_format
  before_action :api_authentication_required

  protect_from_forgery with: :null_session

  #rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Timeout::Error, with: :timeout_response
  rescue_from CanCan::AccessDenied, with: :unauthorized

  private

  # Require authentication when this before filter is used
  def api_authentication_required
    unauthorized unless current_user?
  end

  # Return a 415 error if request is in an unsupported format
  def check_request_format
    unless request.content_type == 'application/json'
      error = ErrorSerializer.serialize({ format: "Invalid request format. Only JSON requests are supported." })
      render json: error, status: :unsupported_media_type
    end
  end

  # Called if an ActiveRecord::RecordNotFound error is raised to return
  # a proper json response
  def record_not_found
    render json: ErrorSerializer.serialize({ record: "Record not found." }), status: :not_found
  end

  def set_time_zone
    Time.use_zone("UTC") { yield }
  end

  def timeout_response(exception)
    render json: ErrorSerializer.serialize({ request: "Request timeout" }), status: :internal_server_error
  end

  def unauthorized
    render json: ErrorSerializer.serialize({ unauthorized: "This request requires authentication." }), status: :unauthorized
  end
end
