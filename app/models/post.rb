class Post < ApplicationRecord
  include Notifiable
  acts_as_votable
  acts_as_taggable_on :hashtag, :athletes_tagged

  belongs_to :athlete
  belongs_to :parent, polymorphic: true
  has_many :comments, as: :commentable
  has_many :reactions, as: :parent, class_name: "Post"
  has_one :image
  has_one :video
  has_many :flaggings

  enum content_type: { image: 0, video: 1 }
  enum status: { pending: 0, complete: 1, error: 2, blocked: 3, archived: 4 }

  scope :original, -> { where('parent_id IS NULL') }
  scope :hot, -> { order(rank: :desc) }
  scope :date_asc, -> { order(created_at: :asc) }

  validates_presence_of :athlete_id

  def image_profiles
    {
      thumbnail_url: image&.file&.url(:thumb) || thumbnail_url,
      medium_url: image&.file&.url(:medium),
      large_url: image&.file&.url(:large),
      x_large_url: image&.file&.url(:x_large)
    }
  end

  def owner_name
    athlete.name
  end

  def parent_object
    parent_type.capitalize.constantize.where(id: self.parent_id).first
  end

  def parent_athlete
    parent_object&.athlete
  end

  def push_response(user)
    "#{user.name} just reacted to a post."
  end

  def question?
    parent_type == "Question"
  end

  def tagged_athletes
    Athlete.where(id: athletes_tagged_list)
  end

  def video_profiles
    profiles = video&.translated_profiles || {}
    profiles.merge(thumbnail_url: thumbnail_url)
  end

  def update_shares!
    increment(:shares)
  end

end
