require "rails_helper"

shared_examples_for "avatarable" do
  let(:model) { described_class }

  it "returns an avatar" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym)
    expect(person.avatar).not_to be nil
  end

  it "returns nil if the avatar does not have a file" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym)
    expect(person.avatar_url).to be nil
    expect(person.avatar_url(:thumb)).to be nil
    expect(person.avatar_url(:medium)).to be nil
  end
end
