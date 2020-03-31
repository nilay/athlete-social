require "rails_helper"

RSpec.describe Athlete, type: :model do
  it { should have_many(:received_invitations) }
  it { should have_many(:posts) }
  it { should have_many(:comments) }

  it_behaves_like "personable"
  it_behaves_like "questioner"
  it_behaves_like "uniqueable"
  it_behaves_like "blockable"
  it_behaves_like "avatarable"
  it_behaves_like "metable"
  it_behaves_like "inviter"

end
