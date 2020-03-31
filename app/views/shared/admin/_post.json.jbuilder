json.cache! [ "admin", post ] do
  json.id   post.id
  json.content_type   post.content_type
  json.created_at  post.created_at
  json.share_count post.share_count
  json.hashtags post.hashtag_list
  json.mentions do
    post.tagged_athletes.each do |athlete|
      if athlete
        json.partial! 'shared/admin/athlete', athlete: athlete, complete: false
      else
        ReportError.call(exception: "Athlete was tagged in post #{post.id} but could not be found")
        nil
      end
    end
  end

  if post.content_type == "video"
    json.urls post.video_profiles
  elsif post.content_type == "image"
    json.urls post.image_profiles
  end
end

unless defined?(complete) && complete == false
  json.athlete do
    if post.athlete
      json.partial! 'shared/admin/athlete', athlete: post.athlete, complete: false
    else
      ReportError.call(exception: "Athlete #{post.athlete_id} could not be found for post #{post.id}")
      nil
    end
  end
end
