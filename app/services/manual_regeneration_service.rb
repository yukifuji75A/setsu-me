class ManualRegenerationService
  Result = Struct.new(:success?, :error, keyword_init: true)

  def initialize(user, theme, answer_params)
    @user = user
    @theme = theme
    @answer_params = answer_params
  end

  def call
    manual = @user.manuals.find_by(theme: @theme)
    return Result.new(success?: false, error: :not_published) if manual.nil? || !manual.published?
    return Result.new(success?: false, error: :limit_exceeded) unless manual.regeneration_available?

    questions = Question.where(theme: @theme).order(:position).includes(:question_options)
    unless AnswerSaveService.new(@user, questions, @answer_params).call
      return Result.new(success?: false, error: :invalid_answers)
    end

    result = ManualGeneratorService.new(@user, @theme).call
    ManualPersistService.new(@user).call(@theme, result)

    Result.new(success?: true, error: nil)
  rescue StandardError
    Result.new(success?: false, error: :generation_failed)
  end
end
