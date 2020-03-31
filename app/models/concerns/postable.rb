module Postable
  extend ActiveSupport::Concern

  def answers
    posts.where(parent_type: 'Question')
  end

  def reactions
    posts.where('parent_id IS NOT NULL').where(parent_type: 'Post')
  end
end
