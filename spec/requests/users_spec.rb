require 'rails_helper'

RSpec.describe "Users", type: :request do
  let (:base_title) {"Serve"}



  describe '#signup' do
    it 'HTTPレスポンスを正常に返すこと User Signup' do
      get signup_path
      expect(response).to have_http_status :ok
    end

    it '新規登録 | Serve が含まれていること' do
      get signup_path
      expect(response.body).to include "新規登録 | #{base_title}"
    end
  end



  describe 'POST /users #create' do
    it '無効なユーザーは登録されないこと' do
      expect {
        post users_path, params: { user: { name: "",
                                          nickname: "Jun",
                                          email: "user@invalid",
                                          password: "foo",
                                          password_confirmation: "bar" }}
      }.to_not change(User, :count)

      expect(response).to have_http_status :unprocessable_entity
      expect(response).to render_template("users/new")
      
    end
  end

  context '有効な値の場合' do
    before do
      ActionMailer::Base.deliveries.clear
    end
    let(:user_params) { { user: { name: "Example User",
                                  nickname: "Example",
                                  email: "user@example.com",
                                  password: "password",
                                  password_confirmation: "password" } } }
      it '登録されていること' do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by(1)
      end

      # it 'users/show(マイページ)にリダイレクトされること' do
      #   post users_path, params: user_params
      #   user = User.last
      #   expect(response).to redirect_to user
      # end

      it 'flashが表示されていること' do
        post users_path, params: user_params
        expect(flash).to be_any
      end

      # it 'ログイン状態であること' do
      #   post users_path, params: user_params
      #   expect(is_logged_in?).to be_truthy
      # end

      it 'メールが1件存在すること' do
        post users_path, params: user_params
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it '登録時点ではactivateされていないこと' do
        post users_path, params: user_params
        expect(User.last).to_not be_activated
      end

  end

  describe 'GET /users' do

    let(:user) { FactoryBot.create(:user) }

    it 'ログインユーザでなければログインページへリダイレクトされること index' do
      get users_path
      expect(response).to redirect_to login_path
    end

    it 'activateされていないユーザは表示されないこと' do
      not_activated_user = FactoryBot.create(:nonactivate)
      log_in user
      get users_path
      expect(response.body).to_not include not_activated_user.name
    end

  end

  describe 'pagination ページネーション' do
    before do
      30.times do
        FactoryBot.create(:continuous_users)
      end
      log_in user
      get users_path
    end

    let(:user) { FactoryBot.create(:user) }

    it 'div.paginationが存在していること' do
      expect(response.body).to include '<ul class="pagination">'
    end

    # it 'ユーザごとのリンクが存在していること' do
    #   User.page(1).each do |user|
    #     expect(response.body).to include "<a href=\"#{user_path(user)}\">"
    #   end
    # end
  end

  describe 'get /users/{id}' do
    it '有効化されていないユーザの場合はrootにリダイレクトすること' do
      user = FactoryBot.create(:user)
      not_activated_user = FactoryBot.create(:nonactivate)
  
      log_in user
      get user_path(not_activated_user)
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET users/{id}/edit' do
    let(:user) { FactoryBot.create(:user) }
    
    it 'HTTPレスポンスを正常に返すこと User edit' do
      log_in user
      get edit_user_path(user)
      expect(response).to have_http_status :ok
    end

    it 'アカウント編集 | Serve が含まれていること' do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include "アカウント編集 | #{base_title}"
    end

    context '未ログインの場合' do
      it 'flashが空ではないこと' do
        get edit_user_path(user)
        expect(flash).to_not be_empty
      end

      it '未ログインユーザはログインページにリダイレクトされること' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it 'ログイン後アカウント編集ページにリダイレクトされること' do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user)
      end
    end

    context '別ユーザの場合' do
      let(:other_user) { FactoryBot.create(:other) }

      it 'flashが空であること' do
        log_in other_user
        get user_path(other_user) # 一度ユーザページへ遷移してからアカウント編集へ
        get edit_user_path(user)
        expect(flash).to be_empty
      end

      it 'ルートパスにリダイレクトされること' do
        log_in other_user
        get user_path(other_user) # 一度ユーザページへ遷移してからアカウント編集へ
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end

  end



  describe 'PATCH /users' do
    let(:user) { FactoryBot.create(:user) }

    context '未ログインの場合' do
      it 'flashが空ではないこと' do
        patch user_path(user), params:  { user: { name: user.name,
                                                  email: user.email } }
        expect(flash).to_not be_empty
      end

      it '未ログインユーザはログインページにリダイレクトされること' do
        patch user_path(user), params:  { user: { name: user.name,
                                                  email: user.email } }
        expect(response).to redirect_to login_path
      end
    end

    context '無効な値の場合' do
      before do
        log_in user
        patch user_path(user), params: { user: { name: '',
                                                  email: 'foo@invlid',
                                                  password: 'foo',
                                                  password_confirmation: 'bar' } }
        end

      it '更新できないこと' do
        user.reload
        expect(user.name).to_not eq ''
        expect(user.nickname).to_not eq ''
        expect(user.email).to_not eq 'foo@invlid'
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end

      it '更新アクション後にeditビューが表示されること' do
        expect(response.body).to include "アカウント編集 | #{base_title}"
      end
    end

    context '有効な値の場合' do
      before do
        @name = 'Foo Bar'
        @nickname = 'FooBarBaz'
        @email = 'foo@bar.com'
        log_in user
        patch user_path(user), params:  { user: { name: @name,
                                                  nickname: @nickname,
                                                  email: @email,
                                                  password: '',
                                                  password_confirmation: '' } }
      end

      it '更新できること' do
        user.reload
        expect(user.name).to eq @name
        expect(user.nickname).to eq @nickname
        expect(user.email).to eq @email
      end
    
      context '別ユーザの場合' do
        let(:other_user) { FactoryBot.create(:other) }

        before do
          log_in other_user
          get user_path(other_user) # 一度ユーザページへ遷移してからアカウント編集へ
          patch user_path(user), params:  { user: { name: user.name,
                                                    email: user.email } }
        end
  
        it 'flashが空であること' do
          expect(flash).to be_empty
        end
  
        it 'ルートパスにリダイレクトされること' do
          expect(response).to redirect_to root_path
        end
      end
    end

    it 'admin属性は変更できないこと' do
      log_in user = FactoryBot.create(:other)
      expect(user).to_not be_admin

      patch user_path(user), params:  { user: { password: 'password',
                                                password_confirmation: 'password',
                                                admin: true }}
      
      user.reload
      expect(user).to_not be_admin
    end
  end

  describe 'DELETE users/id' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other) { FactoryBot.create(:other) }

    context 'adminユーザでログインの場合' do
      it '削除できること' do
        log_in user
        expect {
          delete user_path(other)
        }.to change(User, :count).by -1
      end
    end

    context '未ログインの場合' do
      it '削除できないこと' do
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it 'ログインページにリダイレクトされること' do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    context '管理者admin`ユーザではない場合' do
      it '削除できないこと' do
        log_in other
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it 'rootへリダイレクトされること' do
        log_in other
        delete user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET users/{id}/following' do
    let(:user) { FactoryBot.create(:user) }

    it '未ログインの場合ログインページへリダイレクトされること' do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET users/{id}/followers' do
    let(:user) { FactoryBot.create(:user) }

    it '未ログインの場合ログインページへリダイレクトされること' do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end

  
end
