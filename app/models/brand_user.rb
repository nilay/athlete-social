class BrandUser < ApplicationRecord
  include Challah::Userable
  include Uniqueable
  include Questioner
  include Personable

  belongs_to :brand

  attr_accessor :remember_me
  validates :brand, presence: true

  def self.authorization_model
    BrandUserAuthorization
  end
end
