module Challah
  class CmsAdminTokenTechnique
    def initialize(session)
      @token = session.request.headers["X-Cms-Admin-Auth-Token"].to_s.presence ||
        session.params[:cms_admin_token].to_s
      @controller = session.params[:controller].to_s
    end

    def authenticate
      return nil unless api?

      if cms_admin = CmsAdmin.where(api_key: @token).first
        return cms_admin
      end

      nil
    end

    def persist?
      false
    end

    protected

    # Make sure this request is a part of the API. No token access
    # is allowed in the normal part of the app.
    def api?
      @controller.start_with?("api/")
    end
  end
end
