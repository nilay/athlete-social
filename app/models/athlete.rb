class Athlete < ApplicationRecord
  include Challah::Userable
  include Personable
  include Questioner
  include Avatarable
  include Uniqueable
  include Postable
  include Inviter
  include Blockable
  include Metable

  acts_as_followable
  acts_as_follower
  acts_as_voter

  attr_accessor :invite_token

  validates_with Challah::PasswordValidator, force: true

  # Remove Challah validations for specific attributes
  # This method is setup in such a way that I could easily loop this through several attrs to remove
  # more if we desire to later
  self._validators.delete( :last_name )
  self._validate_callbacks.select do |callback|
    callback.raw_filter.try(:attributes).try(:include?, :last_name); end
  .each do |vc|
    self._validate_callbacks.delete( vc )
  end

  # Set up a new conditional validation for last_name
  validates :last_name, presence: true, unless: Proc.new {|user| ENV["NO_LAST_NAME_IDS"].to_s.split(",").include?(user.id.to_s) }

  has_many :received_invitations, class_name: "Invitation",
                                  foreign_key: "invitee_id"

  has_many :posts
  has_many :comments

  scope :visible, ->{ where(visible: true) }

  def inviters
    Invitation.where(invitee_id: self.id).map(&:inviter)
  end

  def self.authorization_model
    AthleteAuthorization
  end

  def associate_invite_token(invite_token)
    invitation = Invitation.where(invite_token: invite_token).first
    if invitation and !invitation.invalid?
      invitation.update(expires_on: Time.now, invitee_id: id)
    end
  end

  def follower_global_ids
    followers.map{ |f| f.to_global_id.to_s }
  end

  def follower_ids_by_type(follower_type)
    followers_by_type(follower_type).map{ |f| f.to_global_id.to_s }
  end

  def metadata_to_return(user)
    {
      posts_count: posts.original.complete.count,
      reactions_count: reactions.complete.count,
      followers_count: followers_by_type("Athlete").available_for_api.visible.count,
      follow_count: following_by_type("Athlete").available_for_api.visible.count,
      questions_asked_count: (user.is_a?(Fan) ? questions.active.answered.count : questions.active.count),
      questions_answered_count: answers.complete.count,
      liked_posts_count: get_up_voted(Post).count,
      liked_questions_count: get_up_voted(Question).count
    }
  end

end
