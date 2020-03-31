require "rails_helper"

RSpec.describe Invitation, type: :model do

  it "generates an invite_token" do
    athlete = create :athlete
    token = create :invitation, inviter_type: :athlete, inviter_id: athlete.id
    expect(token.invite_token).to_not be_nil
    athlete.destroy
    token.destroy
  end

  it "validates that an athlete does not currently exist" do
    athlete = create :athlete
    other   = create :athlete
    invitation = athlete.create_invitation(email: other.email)
    expect(invitation.errors.full_messages).to eq(["Athlete #{other.email} has already joined Pros."])
  end
end
