class Comment < ApplicationRecord
  acts_as_votable
  belongs_to :commentable, polymorphic: true
  belongs_to :athlete
end
