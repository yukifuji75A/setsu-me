class ManualsController < ApplicationController
  include AnswerInputRestorable

  layout "input", only: [ :step1, :step2, :step3, :show ]
  before_action :set_theme, only: [ :step1, :step2, :step3, :step3_save ]

  def step1
    if current_user.answers.joins(:question).where(questions: { theme: :common }).empty?
      redirect_to edit_common_answers_path, alert: "先に共通情報を入力してください"
      return
    end

    @questions = Question.where(theme: @theme).order(:position).includes(:question_options)
    @answers = current_user.answers.where(question: @questions).index_by(&:question_id)

    return unless request.post?

    if AnswerSaveService.new(current_user, @questions, answer_params).call
      redirect_to step2_manuals_path(theme: @theme)
    else
      restore_answer_inputs(@questions, @answers, answer_params)
      flash.now[:alert] = "全ての質問に回答してください"
      render :step1, status: :unprocessable_entity
    end
  end

  def step2
    result = manual_generator_service.call
    @manual = ManualPersistService.new(current_user).call(@theme, result)
    @basic_spec = @manual.manual_ai_texts.find_by(section_type: :basic_spec)
    @handling_guide = @manual.manual_ai_texts.find_by(section_type: :handling_guide)
  rescue StandardError
    redirect_to step1_manuals_path(theme: @theme), alert: "生成に失敗しました。もう一度お試しください。"
  end

  def step3
    @manual = current_user.manuals.find_by(theme: @theme)
    @profile = current_user.profile
    @common_answers = common_answers_for(current_user)
    @basic_spec = @manual&.manual_ai_texts&.find_by(section_type: :basic_spec)
    @handling_guide = @manual&.manual_ai_texts&.find_by(section_type: :handling_guide)
    @theme_answers = current_user.answers.for_theme(@theme).sort_by { |a| a.question.position }
  end

  def step3_save
    manual = current_user.manuals.find_by!(theme: @theme)
    redirect_to manual_path(manual), notice: "トリセツを発行しました！"
  rescue ActiveRecord::RecordNotFound
    redirect_to step1_manuals_path(theme: @theme), alert: "保存に失敗しました。もう一度お試しください。"
  end

  def show
    @manual = current_user.manuals.find(params[:id])
    @profile = current_user.profile
    @common_answers = common_answers_for(current_user)
    @theme_answers = current_user.answers.for_theme(@manual.theme).sort_by { |a| a.question.position }
    @basic_spec = @manual.manual_ai_texts.find_by(section_type: :basic_spec)
  end

  private

  def set_theme
    @theme = params[:theme]
    head :not_found unless Question.themes.key?(@theme) && @theme != "common"
  end

  def manual_generator_service
    ManualGeneratorService.new(current_user, @theme)
  end

  def common_answers_for(user)
    user.answers.for_theme(:common).sort_by { |a| a.question.position }
  end

  def answer_params
    params.fetch(:answers, {}).permit(
      Question.where(theme: @theme).ids.map { |id| [ id.to_s, [ :question_option_id, :body ] ] }.to_h
    )
  end
end
