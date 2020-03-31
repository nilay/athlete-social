json.partial! 'shared/api/v1/post', post: @post

json.athlete do
  json.partial! 'shared/api/v1/athlete', athlete: @post.athlete, avatar: true
end

json.reactions @post.reactions.complete.date_asc.each do |reaction|
  json.(reaction, :id, :content_type, :created_at)
  json.hashtags reaction.hashtag_list
  json.mentions do
    json.array! reaction.tagged_athletes do |athlete|
      if athlete
        json.partial! 'shared/api/v1/athlete', athlete: athlete, avatar: true
      else
        ReportError.call(exception: "Athlete could not be found but was tagged in post #{reaction.id}")
        nil
      end
    end
  end

  if reaction.content_type == "video"
    json.urls reaction.video_profiles
  elsif reaction.content_type == "image"
    json.urls reaction.image_profiles rescue nil
  else
  end

  json.partial! 'shared/api/v1/athlete', athlete: reaction.athlete, avatar: true
end

json.cache! @post.comments do
  json.comments do
    json.cache_collection! @post.comments do |comment|
      json.id comment.id
      json.text comment.text
      json.created_at comment.created_at
      json.athlete do
        if comment.athlete
          json.partial! 'shared/api/v1/athlete', athlete: comment.athlete, avatar: true
        else
          ReportError.call(exception: "Athlete #{comment.athlete_id} could not be found for comment #{comment.id}")
          nil
        end
      end
    end
  end
end

json.likes do |json|
  json.count @post.get_likes.size
  json.liked_by_current_user current_user.voted_up_on?(@post)
end
