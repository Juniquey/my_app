require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "#create" do
    context '未ログインの場合' do
      it 'ログインページへリダイレクトされること' do
        post relationships_path
        expect(response).to redirect_to login_path
      end

      it '登録ができないこと' do
        expect {
          post relationships_path
        }.to_not change(Relationship, :count)
      end
    end
  end
end