require "rails_helper"

shared_examples_for "notifiable" do
  let(:model) { described_class }
  let(:user) { create :athlete, first_name: "Joe", last_name: "Bagels" }
  describe "instance methods" do
    before do
      @object = FactoryGirl.create(model.to_s.underscore.to_sym)
    end
    context "#add_text" do
      it "returns text with a user" do
        expect(@object.add_text(user)).to eq("Joe Bagels just added a new #{@object.class.to_s.downcase}!")
      end
    end

    context "#deep_link" do
      it "creates a deep link" do
        expect(@object.deep_link).to eq("#{ENV["DEEP_LINK"]}://#{@object.class.to_s.downcase.pluralize}/#{@object.id}")
      end
    end

    context "#personal_response_text" do
      it "creates a personal response text" do
        expect(@object.personal_response_text(user)).to eq("Joe Bagels responded to your #{@object.class.to_s.downcase}.")
      end
    end
  end
end
