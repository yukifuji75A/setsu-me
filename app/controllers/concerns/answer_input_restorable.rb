module AnswerInputRestorable
  extend ActiveSupport::Concern

  private

  def restore_answer_inputs(questions, answers, answer_params)
    answer_params.each do |question_id, answer_data|
      question = questions.find { |q| q.id == question_id.to_i }
      next unless question
      answer = answers[question_id.to_i] || Answer.new(question: question)
      if question.selection?
        answer.question_option_id = answer_data[:question_option_id].presence&.to_i
      else
        answer.body = answer_data[:body]
      end
      answers[question_id.to_i] = answer
    end
  end
end
