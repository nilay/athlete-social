json.cache! ["admin", athlete ], expires_in: 30.minutes do
  json.id  athlete.id
  json.first_name athlete.first_name
  json.last_name athlete.last_name
  json.active athlete.active?
  json.email athlete.email
  json.avatar athlete.avatar, partial: "shared/admin/avatar", as: :avatar
end

unless defined?(complete) && complete == false
  json.posts athlete.posts.complete.each do |post|
    json.partial! 'shared/admin/post', post: post, complete: false
    json.reactions post.reactions.complete.count
    json.comments post.comments.count

    json.likes do |json|
      json.count post.get_likes.size
    end
  end

  json.reactions athlete.reactions.complete.each do |post|
    json.partial! 'shared/admin/post', post: post, complete: false
  end

  json.comments athlete.comments.each do |comment|
    json.id comment.id
    json.text comment.text
    json.created_at comment.created_at
    json.commentable_type comment.commentable_type
    json.commentable_id comment.commentable_id
  end
end
