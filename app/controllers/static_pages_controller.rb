class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @beansposts = current_user.feed.page(params[:page]).per(12) # ページネーションはポスト12個ごとの表示に設定
      @beanspost = current_user.beansposts.build
    end
  end

  def about
  end

  def contact
  end
end
