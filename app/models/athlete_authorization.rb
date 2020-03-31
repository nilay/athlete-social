class AthleteAuthorization < ApplicationRecord
  include Challah::Authorizeable

  def self.user_model
    Athlete
  end
end
