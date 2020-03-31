json.cache! ['web-v1', @post] do
  json.id   @post.id
  json.content_type     @post.content_type
  json.created_at       @post.created_at
  json.poster_image_url @post.thumbnail_url

  if @post.content_type == "video"
    json.urls @post.video_profiles
  elsif @post.content_type == "image"
    json.urls @post.image_profiles
  end
end
json.share_count @post.share_count

json.cache! ['web-v1', @post.athlete] do
  json.athlete do
    if @post.athlete
      athlete = @post.athlete
      json.id  @post.athlete_id
      json.first_name athlete.first_name
      json.last_name athlete.last_name
      json.user_type "Athlete"
      json.avatar do
        json.cache! ['web-v1', athlete.avatar] do
          json.thumbnail_url athlete.avatar_url(:thumb)
          json.medium_url    athlete.avatar_url(:medium)
          json.original_url  athlete.avatar_url
        end
      end
    else
      ReportError.call(exception: "Athlete #{@post.athlete_id} could not be found for post #{@post.id}")
      nil
    end
  end
end


json.reactions @post.reactions.complete.date_asc.each do |reaction|
  json.cache! ['web-v1', reaction] do
    json.id   reaction.id
    json.content_type   reaction.content_type
    json.created_at  reaction.created_at

    if reaction.content_type == "video"
      json.urls reaction.video_profiles
    elsif reaction.content_type == "image"
      json.urls reaction.image_profiles
    end
  end
  json.share_count reaction.share_count

  json.cache! ['web-v1', reaction.athlete] do
    json.athlete do
      if reaction.athlete
        athlete = reaction.athlete
        json.id  reaction.athlete_id
        json.first_name athlete.first_name
        json.last_name athlete.last_name
        json.user_type "Athlete"
        json.avatar do
          json.cache! ['web-v1', athlete.avatar] do
            json.thumbnail_url athlete.avatar_url(:thumb)
            json.medium_url    athlete.avatar_url(:medium)
            json.original_url  athlete.avatar_url
          end
        end
      else
        ReportError.call(exception: "Athlete #{reaction.athlete_id} could not be found for reaction #{reaction.id}")
        nil
      end
    end
  end

  json.likes do |json|
    json.count reaction.get_likes.size
  end
end


json.likes do |json|
  json.count @post.get_likes.size
end
