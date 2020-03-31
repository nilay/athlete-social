require "rails_helper"

RSpec.describe Question, type: :model do
  it_behaves_like "notifiable"

  it { should have_many :reactions }
  it { should validate_presence_of :questioner_id }
  it { should validate_presence_of :questioner_type }

  describe ".answered" do
    before(:example) do
      Question.destroy_all
      athlete = create :athlete
      create_list(:question, 10)
      create :post, parent_id: Question.first.id, parent_type: "Question", status: 1
      create :post, parent_id: Question.last.id, parent_type: "Question", status: 1
    end

    it "gives back answered questions" do
      expect(Question.answered.size).to eq(2)
    end
  end

  describe "#owner_name" do
    before(:example) do
      @cms_admin        = create :cms_admin, first_name: "Bob", last_name: "Ross"
      @cms_question     = create :question, questioner_id: @cms_admin.id, questioner_type: :cms_admin
      @athlete          = create :athlete, first_name: "Jim", last_name: "Slade"
      @athlete_question = create :question, questioner_id: @athlete.id, questioner_type: :athlete
    end

    it "returns the owner name of the question if the owner is a CMS Admin" do
      expect(@cms_question.owner_name).to eq "Bob Ross"
    end

    it "returns the owner name of the question if the owner is an athlete" do
      expect(@athlete_question.owner_name).to eq "Jim Slade"
    end
  end

end
