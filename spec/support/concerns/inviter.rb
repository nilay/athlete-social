require "rails_helper"

shared_examples_for "inviter" do
  let(:model) { described_class }
  let(:email)  { "test@example.com" }
  let(:phone)  { "7045551212" }

  context "with an email" do
    before do
      @person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
      hash = { email: email, name: "Joe Hommywashy" }
      @invite = @person.create_invitation(hash)
    end

    it "creates an invitation" do
      expect(@invite).to be_a Invitation
    end

    it "sets the email and name from the hash" do
      expect(@invite.email).to eq "test@example.com"
      expect(@invite.invitee_name).to eq "Joe Hommywashy"
    end

    it "persists the invite to the database" do
      expect(@invite.persisted?).to be true
    end
  end

  context "with a phone number" do
    before do
      @person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
      hash = { phone: phone , name: "Joe Hommywashy" }
      @invite = @person.create_invitation(hash)
    end

    it "creates an invitation" do
      expect(@invite).to be_an Invitation
    end

    it "persists the invite" do
      expect(@invite.persisted?).to be true
    end

    it "sets name and phone" do
      expect(@invite.phone_number).to eq "7045551212"
      expect(@invite.invitee_name).to eq "Joe Hommywashy"
    end
  end

  context "allows you to see your sent invitations" do
    before do
      @person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
      hash1 = { email: email, name: "Bob Hommywashy" }
      hash2 = { phone: phone , name: "Joe Hommywashy" }
      @invite = @person.create_invitation(hash1)
      @invite2 = @person.create_invitation(hash2)
    end

    it "returns an array" do
      expect(@person.sent_invitations).to be_an ActiveRecord::Relation
    end

    it "returns all invites for a user" do
      expect(@person.sent_invitations.include?(@invite)).to be true
      expect(@person.sent_invitations.include?(@invite2)).to be true
    end
  end

  context "after an invitation is accepted" do
    before do
      @person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
      hash1 = { email: email, name: "Bob Hommywashy" }
      hash2 = { phone: phone , name: "Joe Hommywashy" }
      @invite = @person.create_invitation(hash1)
      @invite2 = @person.create_invitation(hash2)
      @athlete1 = create :athlete, email: email, first_name: "Joe", last_name: "Hommywashy"
      @athlete2 = create :athlete, email: "bob@pros.com", first_name: "Bob", last_name: "Hommywashy"
      @invite.invitee_id = @athlete1.id
      @invite.save
    end

    it "returns an array of invitees" do
      expect(@person.invitees).to be_an Array
    end

    it "includes only athletes who have accepted their invites" do
      expect(@person.invitees.include?(@athlete1)).to be true
      expect(@person.invitees.include?(@athlete2)).to be false
    end
  end
end
