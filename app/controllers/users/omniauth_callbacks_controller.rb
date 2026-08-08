class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      redirect_to new_user_registration_url, alert: "LINEログインに失敗しました。"
    end
  end

  def failure
    redirect_to new_user_session_path, alert: "LINEログインに失敗しました。"
  end
end
