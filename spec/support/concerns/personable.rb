require "rails_helper"

shared_examples_for "personable" do
  let(:model) { described_class }

  it "has a full name" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
    expect(person.name).to eq("Stewart Home")
  end

  it "resets passwords" do
    allow(Faker::Team).to receive(:state).and_return("Maryland")
    allow(Faker::Team).to receive(:creature).and_return("blobfish")
    allow(Random).to receive(:rand).with(99).and_return(66)
    person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
    expect(person.authenticate("test123")).to eq(true)
    expect(PasswordResetJob).to receive(:perform_async).with(person.id, person.class.to_s, "maryland66blobfish")
    person.deliver_password_reset_instructions!
    expect(person.authenticate("test123")).to eq(false)
    expect(person.authenticate("maryland66blobfish")).to eq(true)
  end
end
