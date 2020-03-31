require "challah/password_technique"
require "challah/fan_token_technique"
require "challah/athlete_token_technique"
require "challah/cms_admin_token_technique"
require "challah/authenticators/facebook"
require "challah/facebook/provider"


Challah.options[:skip_routes] = true


Challah.remove_technique(:api_key)
Challah.register_technique :fan_token, Challah::FanTokenTechnique
Challah.register_technique :athlete_token, Challah::AthleteTokenTechnique
Challah.register_technique :cms_admin_token, Challah::CmsAdminTokenTechnique
