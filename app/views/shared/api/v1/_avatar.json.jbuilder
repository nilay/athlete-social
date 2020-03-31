json.cache! ['v1', user.avatar] do
  json.thumbnail_url user.avatar_url(:thumb)
  json.medium_url    user.avatar_url(:medium)
  json.original_url  user.avatar_url
end
