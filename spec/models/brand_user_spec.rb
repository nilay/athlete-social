require "rails_helper"

RSpec.describe BrandUser, type: :model do
  it { should belong_to :brand }
  it_behaves_like "uniqueable"
  it_behaves_like "questioner"
  it { should validate_presence_of :brand }

end
