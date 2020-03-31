# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#  movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#  Character.create(name: 'Luke', movie: movies.first)

athletes = YAML.load_file('lib/athletes.yml')
athletes.values.each do |a|
  athlete = Athlete.where(first_name: a["first_name"],
                        last_name: a["last_name"],
                        email: a["email"].downcase).first_or_initialize
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
