require "rails_helper"

shared_examples_for "metable" do
  let(:model) { described_class }
  let(:user)  { create :fan }

  it "calls the metadata model on the class given a user" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
    expect(person).to receive(:metadata_to_return).with(user)
    person.metadata(user)
  end

  it "calls the metadata model on the class when given no user" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym, first_name: "Stewart", last_name: "Home")
    expect(person).to receive(:metadata_to_return).with(nil)
    person.metadata
  end
end
