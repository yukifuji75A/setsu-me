class SharedManualsController < ActionController::Base
  layout "input"

  def show
    @manual = Manual.find_by!(share_token: params[:share_token])
    @profile = @manual.user.profile
    @common_answers = @manual.user.answers.for_theme(:common).sort_by { |a| a.question.position }
    @theme_answers = @manual.user.answers.for_theme(@manual.theme).sort_by { |a| a.question.position }
    @basic_spec = @manual.manual_ai_texts.find_by(section_type: :basic_spec)
  end
end
