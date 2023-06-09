class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,    only: [:edit, :update, :destroy]
  # before_action :admin_user,      only: :destroy 保留
  before_action :guest_user,      only: [:edit, :update, :destroy]
  
  def index
    @users = User.where(activated: true).page(params[:page]).per(10) # pagenationはユーザ10人ごとの表示に設定
  end

  def show
    @user = User.find(params[:id])
    @beansposts = @user.beansposts.all.page(params[:page]).per(12) # pagenationはポスト12個ごとの表示に設定
    @bookmarks = @user.bookmarks_beansposts.all.page(params[:page]).per(12) # @userがbookmarkしているすべての投稿
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image.attach(params[:user][:image])
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールからアカウントの有効化を行なってください"
      redirect_to root_url
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "更新しました。"
      redirect_to @user
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to root_url, status: :see_other
  end

  def following
    @title = "フォロー"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow', status: :unprocessable_entity
  end

  def followers
    @title = "フォロワー"
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow', status: :unprocessable_entity
  end




  private

    def user_params
      params.require(:user).permit(:name, :nickname, :email, :password, :passwprd_comfirmation, :image)
    end


    # beforeフィルター
    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end

    # 管理者ユーザか確認
    def admin_user
      redirect_to root_url, status: :see_other unless current_user.admin?
    end

    # ゲストユーザーの制限
    def guest_user
      user = User.find_by(email: "guest@example.com")
      if current_user == user
        flash[:warning] = "ゲストユーザの更新・削除はできません。"
        redirect_to user
      end
    end

end
