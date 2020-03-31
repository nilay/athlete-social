json.links links(current_page: @answers.current_page, resource: :answers, total_pages: @answers.total_pages)

json.answers @answers.each do |post|
  json.partial! 'shared/api/v1/post', post: post
  json.cache! post.athlete do
    json.athlete do
      json.partial! 'shared/api/v1/athlete', athlete: post.athlete, avatar: true
    end
  end

  json.reactions post.reactions.complete.date_asc.each do |reaction|
    json.partial! 'shared/api/v1/post', post: reaction
    json.cache! reaction.athlete do
      json.athlete do
        json.partial! 'shared/api/v1/athlete', athlete: reaction.athlete, avatar: true
      end
    end
  end

  json.cache! post.comments do
    json.comments do
      json.cache_collection! post.comments do |comment|
        json.id comment.id
        json.text comment.text
        json.created_at comment.created_at
        json.athlete do
          json.partial! 'shared/api/v1/athlete', athlete: comment.athlete, avatar: true
        end
      end
    end
  end

  json.likes do |json|
    json.count post.get_likes.size
    json.liked_by_current_user current_user.voted_up_on?(post)
  end
end
