class Api::V1::VideosController < Api::V1::ApplicationController
  skip_before_action :check_request_format
  skip_before_action :api_authentication_required

  def new
    video = Video.create
    upload = TelestreamCloud.post('/videos/upload.json', {
      file_name: params[:file_name],
      file_size: params[:file_size].to_i,
      use_all_profiles: true,
      path_format: ":profile/#{video.guid}"
    })
    render json: { upload_url: upload["location"], video_guid: video.guid }
  end

  def notifications
    Rails.logger.info "here's the params:"
    Rails.logger.info params.inspect
    if params['event'] == 'video-encoded'
      VideoEncodingCompletionJob.perform_async(params[:video_id])
    end
  end

  def show
  end

end
