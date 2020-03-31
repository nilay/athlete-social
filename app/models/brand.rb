class Brand < ApplicationRecord
  include Avatarable
  include Postable
  include Metable

  has_many :brand_users

  scope :active, -> { where(deactivated_at: nil) }

  accepts_nested_attributes_for :brand_users

  def metadata_to_return(user)
    {
      questions_asked_count: questions.count,
      questions_answered_count: answers.count,
    }
  end

end
