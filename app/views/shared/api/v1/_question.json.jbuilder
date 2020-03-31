json.cache! ['v1', question] do
  json.id  question.id
  json.text question.text
  json.created_at question.created_at
  json.hashtags question.hashtag_list
  json.mentions do
    json.array! question.tagged_athletes do |athlete|
      if athlete
        json.partial! 'shared/api/v1/athlete', athlete: athlete, avatar: true
      else
        ReportError.call(exception: "Athlete could not be found but was tagged in question #{question.id}")
        nil
      end
    end
  end
end

if defined?(complete) && complete == true
  json.cache! ['v1', question.questioner] do
    json.questioner do |questioner|
      questioner.id question.questioner_id
      questioner.type question.questioner_type
      questioner.name question.questioner.name
      json.avatar question.questioner, partial: "shared/api/v1/avatar", as: :user
    end
  end

  json.reactions question.reactions.complete.date_asc.each do |reaction|
    json.partial! 'shared/api/v1/post', post: reaction

    json.cache! reaction.athlete do
      json.athlete do
        if reaction.athlete
          json.partial! 'shared/api/v1/athlete', athlete: reaction.athlete, avatar: true
        else
          ReportError.call(exception: "Athlete #{reaction.athlete_id} could not be found for question #{question.id}")
          nil
        end
      end
    end
  end

  json.likes do |json|
    json.count question.get_likes.size
    json.liked_by_current_user current_user.voted_up_on?(question)
  end
end
