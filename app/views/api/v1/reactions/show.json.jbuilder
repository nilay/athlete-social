if @post
  json.post do
    json.partial! 'shared/api/v1/post', post: @post, complete: true
  end
end
if @question
  json.question do
    json.partial! 'shared/api/v1/question', question: @question, complete: true
  end
end
json.reaction do
  json.partial! 'shared/api/v1/post', post: @reaction
end
