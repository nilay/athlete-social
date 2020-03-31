json.links links(current_page: @questions.current_page, resource: :questions, total_pages: @questions.total_pages)

json.questions @questions.each do |question|
  json.partial! 'shared/api/v1/question', question: question, complete: true
end
