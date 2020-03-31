namespace :seed do

  desc "fills database with wonderful athlete data!"
  task athletes: :environment do
    puts "destroying all current athletes"
    Athlete.destroy_all
    puts "filling the database with new athletes"
    65.times do
      FactoryGirl.create :athlete
    end
    puts "filling athlete avatars"
    #Athlete.all.map { |a| AvatarDownloader.call(a.avatar.id, Faker::Avatar.image) }
  end

  desc "fills database with fans!"
  task fans: :environment do
    puts "destroying all current fans"
    Fan.destroy_all
    puts "filling the database with new fans"
    20.times do
      FactoryGirl.create :fan
    end
    puts "filling fan avatars"
    #Fan.all.map { |f| AvatarDownloader.call(f.avatar.id, Faker::Avatar.image) }
  end

  desc "creates a bunch of questions from athletes"
  task questions: :environment do
    puts "destroying all current Questions"
    Question.destroy_all
    puts "creating new questions"
    50.times do
      a = Athlete.limit(1).order("RANDOM()").first
      FactoryGirl.create :question, questioner_id: a.id, questioner_type: "athlete", text: Faker::Lorem.sentences(1).first
    end
  end

  desc "destroys votes"
  task no_votes: :environment do
    Vote.destroy_all
  end

  desc "destroys Follows"
  task no_follows: :environment do
    Follow.destroy_all
  end

  desc "like some questions"
  task fan_likes: :environment do
    Fan.limit(10).order("RANDOM()").each do |fan|
      questions = Question.limit(2).order("RANDOM()")
      questions.map { |q| ContentLiker(q, fan) }
    end
  end

  desc "athletes like some questions"
  task athlete_likes: :environment do
    Athlete.limit(10).order("RANDOM()").each do |ath|
      questions = Question.limit(2).order("RANDOM()")
      questions.map { |q| ContentLiker(q, ath) }
    end
  end

  desc "sets up some follows from fan to athletes"
  task fan_follows: :environment do
    Fan.limit(10).order("RANDOM()").each do |fan|
      athletes = Athlete.limit(3).order("RANDOM()")
      athletes.map { |a| AthleteFollower.call(a, fan) }
    end
  end

  desc "sets up some follows from athletes to other athletes"
  task athlete_follows: :environment do
    Athlete.limit(20).order("RANDOM()").each do |ath|
      athletes = Athlete.limit(3).order("RANDOM()")
      athletes.map { |a| AthleteFollower.call(a, ath) }
    end
  end

  desc "seeds real athletes data"
  task real_athletes: :environment do
    athletes = YAML.load_file('lib/athletes.yml')
    athletes.values.each do |a|
      athlete = Athlete.where(first_name: a["first_name"],
                            last_name: a["last_name"],
                            email: a["email"]).first_or_initialize
      if athlete.new_record?
        athlete.password = "abc123"
        athlete.password_confirmation = "abc123"
        athlete.save
      end
      if a["avatar"]
        athlete.avatar.file = URI.parse(a["avatar"])
        athlete.save!
      end
      puts "#{athlete.first_name} #{athlete.last_name} created!"
    end
  end

  desc "The whole dang shebang"
  task every_dang_thang: :environment do
    unless Rails.env == "production"
      puts "nuking your Cms Admins"
      CmsAdmin.destroy_all
      puts "destroying all current athletes"
      Athlete.destroy_all
      puts "destroying all current fans"
      Fan.destroy_all
      puts "destroying all current avatars"
      Avatar.destroy_all
      puts "destroying all current Questions"
      Question.destroy_all
      puts "deleting all posts"
      Post.destroy_all
      puts "deleting all comments"
      Comment.destroy_all
    end

    puts "creating a new CmsAdmin"
    user = CmsAdmin.new(first_name: "OB", last_name: "Admin", email: "admin@challah.me",
      password: "admin123", password_confirmation: "admin123")
    user.save
    AvatarDownloader.call(user.avatar.id, nil, Faker::Avatar.image)

    puts "creating an OB athlete"
    user = Athlete.new(first_name: "OB", last_name: "Athlete", email: "obathlete@challah.me",
      password: "test123", password_confirmation: "test123")
    user.save
    AvatarDownloader.call(user.avatar.id, nil, Faker::Avatar.image)

    puts "creating an OB fan"
    user = Fan.new(first_name: "OB", last_name: "Fan", email: "obfan@challah.me",
      password: "test123", password_confirmation: "test123")
    user.save
    AvatarDownloader.call(user.avatar.id, nil, Faker::Avatar.image)

    puts "filling the database with new athletes"
    65.times do
      FactoryGirl.create :athlete
    end

    puts "filling athlete avatars"
    if ENV["AWS_S3_BUCKET"]
      Athlete.all.map { |a| AvatarDownloader.call(a.avatar.id, nil, Faker::Avatar.image) }
    end

    puts "filling the database with new fans"
    20.times do
      FactoryGirl.create :fan
    end

    puts "filling fan avatars"
    if ENV["AWS_S3_BUCKET"]
      Fan.all.map { |f| AvatarDownloader.call(f.avatar.id, nil, Faker::Avatar.image) }
    end

    puts "creating new questions"
    50.times do
      a = Athlete.limit(1).order("RANDOM()").first
      FactoryGirl.create :question, questioner_id: a.id, questioner_type: "athlete", text: Faker::Lorem.sentences(1).first, status: Question.statuses.keys.sample
    end

    puts "creating some random likes for questions"
    Fan.limit(10).order("RANDOM()").each do |fan|
      questions = Question.limit(2).order("RANDOM()")
      questions.map { |q| ContentLiker.call(q, fan) }
    end
    Athlete.limit(10).order("RANDOM()").each do |ath|
      questions = Question.limit(2).order("RANDOM()")
      questions.map { |q| ContentLiker.call(q, ath) }
    end

    puts "creating some random followings for athletes"
    Fan.limit(10).order("RANDOM()").each do |fan|
      athletes = Athlete.limit(3).order("RANDOM()")
      athletes.map { |a| AthleteFollower.call(a, fan) }
    end
    Athlete.limit(20).order("RANDOM()").each do |ath|
      athletes = Athlete.limit(3).order("RANDOM()")
      athletes.map { |a| AthleteFollower.call(a, ath) }
    end

    puts "creating a bunch of random posts"
    Athlete.all.each do |a|
      3.times do
        Post.create(athlete: a,
                    content_type: "image",
                    status: "complete",
                    url: Faker::Avatar.image,
                    thumbnail_url: Faker::Avatar.image("my-slug", "100x100"))
      end
    end

    puts "commenting on the random posts"
    Athlete.all.each do |a|
      5.times do
        Comment.create(athlete_id: a.id, text: Faker::Lorem.sentences(1).first, commentable_type: "Post", commentable_id: Post.limit(1).order("RANDOM()").first.id)
      end
    end
  end
end
