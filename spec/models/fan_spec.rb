require "rails_helper"

RSpec.describe Fan, type: :model do
  it_behaves_like "personable"
  it_behaves_like "uniqueable"
  it_behaves_like "avatarable"
  it_behaves_like "metable"
end
