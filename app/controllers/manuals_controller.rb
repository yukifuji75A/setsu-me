class ManualsController < ApplicationController
  layout "input", only: [ :step1, :step2, :step3, :show ]
  def step1
    if current_user.answers.joins(:question).where(questions: { theme: :common }).empty?
      redirect_to edit_common_answers_path, alert: "先に共通情報を入力してください"
      return
    end

    @questions = Question.default.order(:position).includes(:question_options)
    @answers = current_user.answers.where(question: @questions).index_by(&:question_id)

    return unless request.post?

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
    redirect_to step2_manuals_path
  rescue ActiveRecord::RecordInvalid
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
    render :step1, status: :unprocessable_entity
  end

  def step2
    result = ManualGeneratorService.new(current_user).call

    manual = current_user.manuals.find_or_initialize_by(theme: :default)
    manual.save!

    manual.manual_ai_texts.find_or_initialize_by(section_type: :basic_spec).tap do |t|
      t.ai_text = result[:basic_spec]
      t.save!
    end

    manual.manual_ai_texts.find_or_initialize_by(section_type: :handling_guide).tap do |t|
      t.ai_text = result[:handling_guide]
      t.save!
    end

    @manual = manual
    @basic_spec = manual.manual_ai_texts.find_by(section_type: :basic_spec)
    @handling_guide = manual.manual_ai_texts.find_by(section_type: :handling_guide)
  rescue StandardError
    redirect_to step1_manuals_path, alert: "生成に失敗しました。もう一度お試しください。"
  end

  def step3
    @manual = current_user.manuals.find_by(theme: :default)
    @profile = current_user.profile
    @common_answers = common_answers_for(current_user)
    @basic_spec = @manual&.manual_ai_texts&.find_by(section_type: :basic_spec)
    @handling_guide = @manual&.manual_ai_texts&.find_by(section_type: :handling_guide)
  end

  def step3_save
    manual = current_user.manuals.find_by!(theme: :default)
    redirect_to manual_path(manual), notice: "トリセツを発行しました！"
  rescue ActiveRecord::RecordNotFound
    redirect_to step1_manuals_path, alert: "保存に失敗しました。もう一度お試しください。"
  end

  def show
    @manual = current_user.manuals.find(params[:id])
    @profile = current_user.profile
    @common_answers = common_answers_for(current_user)
    @default_answers = current_user.answers
                                   .joins(:question)
                                   .where(questions: { theme: :default })
                                   .includes(:question, :question_option)
                                   .sort_by { |a| a.question.position }
    @basic_spec = @manual.manual_ai_texts.find_by(section_type: :basic_spec)
  end

  private

  def common_answers_for(user)
    user.answers
        .joins(:question)
        .where(questions: { theme: :common })
        .includes(:question, :question_option)
        .sort_by { |a| a.question.position }
  end

  def answer_params
    params.fetch(:answers, {}).permit(
      Question.default.ids.map { |id| [ id.to_s, [ :question_option_id, :body ] ] }.to_h
    )
  end
end
