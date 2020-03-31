class Fan < ApplicationRecord
  include Challah::Userable
  include Personable
  include Avatarable
  include Uniqueable
  include Blockable
  include Metable

  acts_as_follower
  acts_as_voter

  validates_with Challah::PasswordValidator, force: true

  def self.authorization_model
    FanAuthorization
  end

  def metadata_to_return(user)
    {
      follow_count: follow_count,
      liked_posts_count: get_up_voted(Post).count,
      liked_questions_count: get_up_voted(Question).count
    }
  end
end
