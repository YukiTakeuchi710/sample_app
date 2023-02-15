require 'rails_helper'

RSpec.describe "likes", type: :request do

  before do
    @user = FactoryBot.create(:user)
    @micropost = FactoryBot.create(:micropost)
  end
  describe "POST likes" do

    it  "react Like" do
      sign_in @user
      expect {
        post likes_path, params: { micropost_id: @micropost.id }
      }.to change(@micropost.likes, :count).by(1)
    end
  end
  describe "DELETE likes" do

    it  "cancel Like reaction" do
      sign_in @user
      expect {
        post likes_path, params: { micropost_id: @micropost.id }
      }.to change(@micropost.likes, :count).by(1)
      expect {
        delete "/likes/" + @micropost.id.to_s, params: { id: @micropost.id }
      }.to change(@micropost.likes, :count).by(-1)
    end

  end
end
