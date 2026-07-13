class CommonAnswersController < ApplicationController
  layout "input"
  def edit
    @questions = Question.common.order(:position).includes(:question_options)
    @answers = current_user.answers.where(question: @questions).index_by(&:question_id)
  end

  def update
    @questions = Question.common.order(:position).includes(:question_options)

    ActiveRecord::Base.transaction do
      @questions.each do |question|
        answer_data = answer_params[question.id.to_s] || {}
        answer = current_user.answers.find_or_initialize_by(question_id: question.id)
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
    redirect_to mypage_path, notice: "共通情報を保存しました"
  rescue ActiveRecord::RecordInvalid
    @answers = current_user.answers.where(question: @questions).index_by(&:question_id)
    answer_params.each do |question_id, answer_data|
      question = @questions.find { |q| q.id == question_id.to_i }
      next unless question
      answer = @answers[question_id.to_i] || Answer.new(question: question)
      if question.selection?
        answer.question_option_id = answer_data[:question_option_id].presence&.to_i
      else
        answer.body = answer_data[:body]
      end
      @answers[question_id.to_i] = answer
    end
    flash.now[:alert] = "全ての質問に回答してください"
    render :edit, status: :unprocessable_entity
  end

  private

  def answer_params
    params.fetch(:answers, {}).permit(
      Question.common.ids.map { |id| [ id.to_s, [ :question_option_id, :body ] ] }.to_h
    )
  end
end
