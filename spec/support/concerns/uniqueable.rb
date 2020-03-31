require "rails_helper"

shared_examples_for "uniqueable" do
  let!(:model) { described_class }
  let!(:fan) { Fan.create(first_name: "Richard", last_name: "Nixon", email: "stew@challah.me", password: "asdf", password_confirmation: "asdf") }

  it "will protect uniqueness across scopes for emails" do
    new_person = model.new(first_name: "Stewart", last_name: "Home", email: "stew@challah.me")
    new_person.valid?
    expect(new_person.errors.full_messages).to include("Email can't belong to another user")
  end
end
