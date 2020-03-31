json.cache! ['v1', post], expires_in: 1.minutes do
  json.id   post.id
  json.content_type   post.content_type
  json.created_at  post.created_at
  json.hashtags post.hashtag_list
  json.share_url "#{ENV['DOMAIN']}/posts/#{post.id}"
  json.share_text "#{ENV['SHARE_TEXT']}"
  json.mentions do
    json.cache! post.tagged_athletes do
      json.array! post.tagged_athletes do |athlete|
        if athlete
          json.id  athlete.id
          json.first_name athlete.first_name
          json.last_name athlete.last_name
          json.user_type "Athlete"

          json.cache! ['v1', athlete.avatar] do
            json.avatar athlete, partial: "shared/api/v1/avatar", as: :user
          end
        else
          ReportError.call(exception: "Athlete could not be found but was tagged in post #{post.id}")
          nil
        end
      end
    end
  end

  if post.content_type == "video"
    json.urls post.video_profiles
  elsif post.content_type == "image"
    json.urls post.image_profiles
  end

end

json.share_count post.share_count

json.cache! ['v1', post.athlete] do
  json.athlete do
    if post.athlete
      athlete = post.athlete

      json.id  athlete.id
      json.first_name athlete.first_name
      json.last_name athlete.last_name
      json.user_type "Athlete"
      json.cache! ['v1', athlete.avatar] do
        json.avatar athlete, partial: "shared/api/v1/avatar", as: :user
      end

    else
      ReportError.call(exception: "Athlete #{post.athlete_id} could not be found for post #{post.id}")
      nil
    end
  end
end

if defined?(complete) && complete == true
  json.reactions post.reactions.complete.date_asc.each do |reaction|
    json.partial! 'shared/api/v1/post', post: reaction
  end

  json.comments do
    json.cache_collection! post.comments do |comment|
      json.id comment.id
      json.text comment.text
      json.created_at comment.created_at
      json.athlete do
        if comment.athlete
          athlete = comment.athlete

          json.id  athlete.id
          json.first_name athlete.first_name
          json.last_name athlete.last_name
          json.user_type "Athlete"
          json.cache! ['v1', athlete.avatar] do
            json.avatar athlete, partial: "shared/api/v1/avatar", as: :user
          end

        else
          ReportError.call(exception: "Athlete #{comment.athlete_id} could not be found for comment #{comment.id}")
          nil
        end
      end
    end
  end

  json.likes do |json|
    json.cache! ['v1', post.get_likes] do
      json.count post.get_likes.size
    end
    json.liked_by_current_user current_user.voted_up_on?(post)
  end
end
