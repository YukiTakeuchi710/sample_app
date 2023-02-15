require 'rails_helper'

RSpec.describe "likes", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @micropost = FactoryBot.create(:micropost)
    @other_user = FactoryBot.create(:user)
  end

  describe "Follow Other User" do

    it  "followers Number is added" do
      sign_in @user
      expect {
        post relationships_path, params: { followed_id: @other_user.id }
      }.to change(@other_user.followers, :count).by(1)
    end

    it  "followings Number is added" do
      sign_in @user
      expect {
        post relationships_path, params: { followed_id: @other_user.id }
      }.to change(@user.following, :count).by(1)
    end
  end
  describe "Cancel Follows" do

    it  "followers count does not change" do
      sign_in @user
      expect {
        post relationships_path, params: { followed_id: @other_user.id }
      }.to change(@other_user.followers, :count).by(1)
      expect {
        delete "/relationships/" + @user.id.to_s, params: { id: @user.id }
      }.to change(@other_user.followers, :count).by(-1)
    end

    it  "following count does not change" do
      sign_in @user
      expect {
        post relationships_path, params: { followed_id: @other_user.id }
      }.to change(@user.following, :count).by(1)
      expect {
        delete "/relationships/" + @user.id.to_s, params: { id: @user.id }
      }.to change(@user.following, :count).by(-1)
    end
  end
end
