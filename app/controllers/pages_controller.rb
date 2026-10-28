class PagesController < ApplicationController
  layout "top"
  skip_before_action :authenticate_user!, only: [ :top ]
  skip_before_action :require_profile, only: [ :top ]
  before_action :redirect_signed_in_user, only: [ :top ]

  def top
  end

  private

  def redirect_signed_in_user
    redirect_to mypage_path if user_signed_in?
  end
end
