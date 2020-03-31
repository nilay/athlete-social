json.account_status @me.account_status
json.avatar @me.avatar, partial: "shared/admin/avatar", as: :avatar
json.first_name @me.first_name
json.id  @me.id
json.last_name @me.last_name
json.metadata @me.metadata
json.status @me.status

json.followers @me.followers_by_type("Athlete").available_for_api.each do |athlete|
  json.id  athlete.id
  json.first_name athlete.first_name
  json.last_name athlete.last_name
  json.avatar athlete.avatar, partial: "shared/admin/avatar", as: :avatar
end

json.posts @me.posts.complete.each do |post|
  json.id   post.id
  json.content_type   post.content_type
  json.created_at  post.created_at
  json.share_count post.share_count
  json.hashtags post.hashtag_list
  json.mentions post.tagged_athletes, partial: 'shared/admin/athlete', as: :athlete

  if post.content_type == "video"
    json.urls post.video_profiles
  elsif post.content_type == "image"
    json.urls post.image_profiles
  end
end

json.reactions @me.reactions.complete.each do |post|
  json.id   post.id
  json.content_type   post.content_type
  json.created_at  post.created_at
  json.share_count post.share_count
  json.hashtags post.hashtag_list
  json.mentions post.tagged_athletes, partial: 'shared/admin/athlete', as: :athlete

  if post.content_type == "video"
    json.urls post.video_profiles
  elsif post.content_type == "image"
    json.urls post.image_profiles
  end
end

json.answers @me.answers.complete.each do |post|
  json.id   post.id
  json.content_type   post.content_type
  json.created_at  post.created_at
  json.share_count post.share_count
  json.hashtags post.hashtag_list
  json.mentions post.tagged_athletes, partial: 'shared/admin/athlete', as: :athlete

  if post.content_type == "video"
    json.urls post.video_profiles
  elsif post.content_type == "image"
    json.urls post.image_profiles
  end
end
