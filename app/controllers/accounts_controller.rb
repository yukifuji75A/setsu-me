class AccountsController < ApplicationController
  layout "input"
  before_action :reject_line_user

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_with_password(account_params)
      bypass_sign_in(@user)
      redirect_to mypage_path, notice: "アカウント情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def reject_line_user
    redirect_to mypage_path, alert: "LINEログインではメールアドレス・パスワードの変更はできません" if current_user.line_user?
  end

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
