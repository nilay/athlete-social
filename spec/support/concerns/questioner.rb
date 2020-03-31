require "rails_helper"

shared_examples_for "questioner" do
  let(:model) { described_class }

  it "has a full name" do
    person = FactoryGirl.create(model.to_s.underscore.to_sym)
    question = FactoryGirl.create(:question, text: "Wha?", questioner_type: model.to_s.underscore, questioner_id: person.id)
    expect(person.questions).to eq([question])
  end
end
