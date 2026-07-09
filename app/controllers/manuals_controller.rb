class ManualsController < ApplicationController
  def step1
    @questions = Question.default.order(:position).includes(:question_options)
    @answers = current_user.answers.where(question: @questions).index_by(&:question_id)

    return unless request.post?

    ActiveRecord::Base.transaction do
      answer_params.each do |question_id, answer_data|
        question = Question.find(question_id)
        answer = current_user.answers.find_or_initialize_by(question_id: question_id)
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
    flash.now[:alert] = "入力内容を確認してください"
    render :step1, status: :unprocessable_entity
  end

  def step2
    result = ManualGeneratorService.new(current_user).call
    @basic_spec = result[:basic_spec]
    @handling_guide = result[:handling_guide]
    session[:basic_spec] = @basic_spec
    session[:handling_guide] = @handling_guide
  rescue StandardError
    redirect_to step1_manuals_path, alert: "生成に失敗しました。もう一度お試しください。"
  end

  def step3
    @basic_spec = session[:basic_spec]
    @handling_guide = session[:handling_guide]
  end

  def step3_save
    manual = current_user.manuals.find_or_initialize_by(theme: :default)
    manual.save!

    manual.manual_ai_texts.find_or_initialize_by(section_type: :basic_spec).tap do |t|
      t.ai_text = session[:basic_spec]
      t.save!
    end

    manual.manual_ai_texts.find_or_initialize_by(section_type: :handling_guide).tap do |t|
      t.ai_text = session[:handling_guide]
      t.save!
    end

    session.delete(:basic_spec)
    session.delete(:handling_guide)

    redirect_to mypage_path, notice: "トリセツを発行しました！"
  rescue StandardError
    redirect_to step3_manuals_path, alert: "保存に失敗しました。もう一度お試しください。"
  end

  private

  def answer_params
    params.fetch(:answers, {}).permit(
      Question.default.ids.map { |id| [ id.to_s, [ :question_option_id, :body ] ] }.to_h
    )
  end
end
