json.metadata do
  json.posts_count @metadata[:posts_count]
  json.reactions_count @metadata[:reactions_count]
  json.followers_count @metadata[:followers_count]
  json.follow_count @metadata[:follow_count]
  json.questions_asked_count @metadata[:questions_asked_count]
  json.questions_answered_count @metadata[:questions_answered_count]
  json.liked_posts_count @metadata[:liked_posts_count]
  json.liked_questions_count @metadata[:liked_questions_count]
  if @user.respond_to?(:followed_by?)
    json.followed_by_current_user @user.followed_by?(current_user)
  end
end
