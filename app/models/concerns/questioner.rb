module Questioner
  extend ActiveSupport::Concern

  def build_question(params)
    Question.new(questioner_id: id,
                    questioner_type: self.class.to_s.underscore.to_sym,
                    text: params[:text])
  end

  def questions
    Question.where(questioner_id: id, questioner_type: self.class.to_s.underscore.to_sym)
  end
end
