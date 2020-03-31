class Question < ApplicationRecord
  include Notifiable

  acts_as_votable
  acts_as_taggable_on :hashtag, :athletes_tagged

  enum questioner_type: { athlete: 0, brand_user: 1, cms_admin: 2 }
  enum status: { active: 0, inactive: 1, archived: 2 }
  has_many :reactions, as: :parent, class_name: "Post"
  validates :questioner_type, :questioner_id, presence: true

  def athlete
    questioner if questioner_type == "athlete"
  end

  def owner_name
    questioner.name
  end

  def push_response(user)
    "#{user.name} just answered a question."
  end

  def tagged_athletes
    Athlete.where(id: athletes_tagged_list)
  end

  def questioner
    questioner_type.classify.constantize.where(id: questioner_id).first
  end

  def self.answered
    includes(:reactions).where("(select count(*) from posts where parent_type='Question' AND parent_id=questions.id AND status=1) > 0")
  end

end
