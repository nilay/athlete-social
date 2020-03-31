json.cache! ['v1', athlete] do
  json.id  athlete.id
  json.first_name athlete.first_name
  json.last_name athlete.last_name
  json.user_type "Athlete"
end
if defined?(avatar) && avatar == true
  json.avatar athlete, partial: "shared/api/v1/avatar", as: :user
end
