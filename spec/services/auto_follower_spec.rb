require "rails_helper"

RSpec.describe AutoFollower, type: :service do
  before do
    Athlete.destroy_all
  end
  
  describe ".call" do
    before(:example) do
      @following_athletes = create_list(:athlete, 10)
      @non_following_athletes = create_list(:athlete, 10)
      @all_athletes = @following_athletes + @non_following_athletes
      @follower = create :fan
    end

    it "makes a user bulk follow a group of athletes" do
      @all_athletes.map { |a| expect(@follower.following?(a)).to be false }
      AutoFollower.call(@follower.id, @follower.class, @following_athletes.map(&:id))
      @follower.reload
      @non_following_athletes.map { |a| expect(@follower.following?(a)).to be false }
      @following_athletes.map { |a| expect(@follower.following?(a)).to be true }
    end
  end

  describe ".call without athlete_ids" do
    before(:example) do
      @follower = create :fan
      @yaml = YAML.load_file("lib/athletes.yml")
      @emails = @yaml.values.map{ |v| v["email"] }
      @yaml.values.map { |v| Athlete.create(first_name: v["first_name"], last_name: v["last_name"],
        email: v["email"])}
    end

    it "receives a set of athletes from a config file if no ids are given" do
      AutoFollower.call(@follower.id, @follower.class)
      @follower.reload
      expect(@follower.following_by_type("Athlete").count).to eq(Athlete.all.count)
    end
  end
end
