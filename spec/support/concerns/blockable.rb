require "rails_helper"

shared_examples_for "blockable" do
  let(:model) { described_class }

  it "blocks fans" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym)
    blocked_person = FactoryGirl.create(:fan)
    person.create_block(blocked_person)
    person.blocked_fans.should eq([blocked_person])
  end

  it "blocks athletes" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym)
    blocked_person = FactoryGirl.create(:athlete)
    person.create_block(blocked_person)
    person.blocked_athletes.should eq([blocked_person])
  end
end
