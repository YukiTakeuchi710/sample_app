require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  context "as an authenticated user" do
    before do
      @user = FactoryBot.create(:user)
    end
    # 正常系の投稿
    context "with valid micropost" do
      it "adds a micropost" do
        micropost_params = FactoryBot.attributes_for(:micropost)
        sign_in @user
        expect {
          post microposts_path, params: { micropost: micropost_params }
        }.to change(@user.microposts, :count).by(1)
      end

      it "adds a micropost with jpg" do
        img = fixture_file_upload('kitten.jpg', 'image/jpeg')
        micropost_params = FactoryBot.attributes_for(:micropost)
        micropost_params[:image] = img
        sign_in @user
        expect {
          post microposts_path, params: { micropost: micropost_params }
        }.to change(@user.microposts, :count).by(1)
      end

      it "adds a micropost with gif" do
        img = fixture_file_upload('th.gif', 'image/gif')
        micropost_params = FactoryBot.attributes_for(:micropost)
        micropost_params[:image] = img

        sign_in @user
        expect {
          post microposts_path, params: { micropost: micropost_params }
        }.to change(@user.microposts, :count).by(1)
      end

      it "adds a micropost with png" do
        img = fixture_file_upload('png_test.PNG', 'image/png')
        micropost_params = FactoryBot.attributes_for(:micropost)
        micropost_params[:image] = img

        sign_in @user
        expect {
          post microposts_path, params: { micropost: micropost_params }
        }.to change(@user.microposts, :count).by(1)
      end
    end

    context "with invalid micropost" do
      context "does not add a micropost" do
        it ", because blank content" do
          micropost_params = FactoryBot.attributes_for(:micropost, :blank)
          sign_in @user
          expect {
            post microposts_path, params: { micropost: micropost_params }
          }.to_not change(@user.microposts, :count)
        end
        it ", because wrong fite content-type" do
          micropost_params = FactoryBot.attributes_for(:micropost)
          img = fixture_file_upload('text_test.txt', 'text/plain')
          micropost_params[:image] = img

          sign_in @user
          expect {
            post microposts_path, params: { micropost: micropost_params }
          }.to_not change(@user.microposts, :count)
        end
      end
    end
  end
end
