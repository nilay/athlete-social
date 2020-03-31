require "rails_helper"

RSpec.describe AthleteInviter, type: :service do
  describe ".call" do
    before(:example) do
      @athlete = create :athlete
    end
    let!(:email)   { "test@example.com" }

    subject { AthleteInviter.call(@athlete, email: email) }

    it "creates an invitation" do
      expect(subject).to be_a Invitation
    end
  end

  describe ".call with email" do
    before(:example) do
      @athlete = create :athlete
    end

    it "creates the invite and sends an email if an email is given" do
      mailer = double("mailer")
      invite = double("invitation")
      expect(Invitation).to receive(:create).and_return(invite)
      expect(invite).to receive(:valid?).and_return(true)
      expect(invite).to receive(:email).and_return(@athlete.email)
      expect(InvitationMailer).to receive(:invite_email).with(invite).and_return(mailer)
      expect(mailer).to receive(:deliver)
      AthleteInviter.call(@athlete, { email: "test@example.com", name: "Bubba Briggs" })
    end
  end

  describe ".call with phone number" do
    before(:example) do
      @athlete = create :athlete
    end

    it "creates the invite and sends a text if a phone number is given" do
      invite = double("invitation")
      expect(Invitation).to receive(:create).and_return(invite)
      expect(invite).to receive(:email).and_return(nil)
      expect(invite).to receive(:valid?).and_return(true)
      expect(invite).to receive(:invite_token).and_return("OU812")
      expect(SmsSenderJob).to receive(:perform_async).with("7045551212", "Hi Bubba Briggs, #{@athlete.name} has invited you to be a part of the Pros App.  Click below to join the team. #{ENV["DOMAIN"]}/invite/OU812")
      AthleteInviter.call(@athlete, { phone_number: "7045551212", name: "Bubba Briggs" })
    end

    it "creates the invite and sends a text if a phone number is given with no name" do
      invite = double("invitation")
      expect(Invitation).to receive(:create).and_return(invite)
      expect(invite).to receive(:email).and_return(nil)
      expect(invite).to receive(:valid?).and_return(true)
      expect(invite).to receive(:invite_token).and_return("OU812")
      expect(SmsSenderJob).to receive(:perform_async).with("7045551212", "Hi , #{@athlete.name} has invited you to be a part of the Pros App.  Click below to join the team. #{ENV["DOMAIN"]}/invite/OU812")
      AthleteInviter.call(@athlete, { phone_number: "7045551212" })
    end
  end
end
