class ApplicationController < ActionController::Base
  include SessionsHelper

  # beforeフィルター
  #ログイン済みユーザか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインが必要です。"
      redirect_to login_url, status: :see_other
    end
  end

end
