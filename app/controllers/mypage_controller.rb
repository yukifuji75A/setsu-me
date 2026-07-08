class MypageController < ApplicationController
  def show
    @profile = current_user.profile
    @common_answers = current_user.answers
                                  .joins(:question)
                                  .where(questions: { theme: :common })
                                  .includes(:question, :question_option)
                                  .sort_by { |a| a.question.position }
    @manual = current_user.manuals.find_by(theme: :default)
  end
end
