class StaticController < ApplicationController

  def index
  end

  def legal
  end

  def tos
  end

  def tos_app
    redirect_to legal_path(nav: 0)
  end

  def fan_eula
  end

  def athlete_eula
  end

  def apple_app_site_association
    response.headers["Content-Type"] = "application/pkcs7-mime"
    respond_to do |format|
      format.any { render json: app_json  }
    end
  end

  def app_json
    { applinks: { apps: [], details: [{ appID: ENV["DEEP_LINK_ID"], paths: ["*"] }] } }
  end

end
