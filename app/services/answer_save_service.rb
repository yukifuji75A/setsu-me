class AnswerSaveService
  attr_reader :errors

  def initialize(user, questions, answer_params)
    @user = user
    @questions = questions
    @answer_params = answer_params
    @errors = []
  end

  def call
    ActiveRecord::Base.transaction do
      @questions.each do |question|
        answer_data = @answer_params[question.id.to_s] || {}
        answer = @user.answers.find_or_initialize_by(question_id: question.id)
        if question.selection?
          answer.question_option_id = answer_data[:question_option_id]
          answer.body = nil
        else
          answer.body = answer_data[:body]
          answer.question_option_id = nil
        end
        answer.save!
      end
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end
end
