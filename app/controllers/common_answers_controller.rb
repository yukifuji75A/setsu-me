class CommonAnswersController < ApplicationController
  include AnswerInputRestorable

  layout "input"
  def edit
    @questions = Question.common.order(:position).includes(:question_options)
    @answers = current_user.answers.where(question: @questions).index_by(&:question_id)
  end

  def update
    @questions = Question.common.order(:position).includes(:question_options)

    if AnswerSaveService.new(current_user, @questions, answer_params).call
      redirect_to mypage_path, notice: "共通情報を保存しました"
    else
      @answers = current_user.answers.where(question: @questions).index_by(&:question_id)
      restore_answer_inputs(@questions, @answers, answer_params)
      flash.now[:alert] = "全ての質問に回答してください"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def answer_params
    params.fetch(:answers, {}).permit(
      Question.common.ids.map { |id| [ id.to_s, [ :question_option_id, :body ] ] }.to_h
    )
  end
end
