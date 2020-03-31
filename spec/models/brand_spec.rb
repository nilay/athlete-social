require 'rails_helper'

RSpec.describe Brand, type: :model do
  it { should have_many :brand_users }
  
end
