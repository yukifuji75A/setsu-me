class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :require_profile

  private

  def require_profile
    return unless user_signed_in?
      return if controller_name == "profiles" || controller_name == "common_answers"
    redirect_to new_profile_path unless current_user.profile.present?
  end

  def after_sign_up_path_for(resource)
    new_profile_path
  end

  def after_sign_in_path_for(resource)
    resource.profile.present? ? mypage_path : new_profile_path
  end
end
