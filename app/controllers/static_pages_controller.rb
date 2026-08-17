class StaticPagesController < ApplicationController
  layout "input"
  skip_before_action :authenticate_user!
  skip_before_action :require_profile

  def terms
  end

  def privacy
  end
end
