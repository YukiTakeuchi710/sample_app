require 'rails_helper'

RSpec.describe "bads", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @micropost = FactoryBot.create(:micropost)
  end
  describe "POST bads" do

    it  "react bad" do
      sign_in @user
      expect {
        post bads_path, params: { micropost_id: @micropost.id }
      }.to change(@micropost.bads, :count).by(1)
    end
  end
  describe "DELETE bads" do
    it  "cancel bad reaction" do
      sign_in @user
      expect {
        post bads_path, params: { micropost_id: @micropost.id }
      }.to change(@micropost.bads, :count).by(1)
      expect {
        delete "/bads/" + @micropost.id.to_s , params: { id: @micropost.id }
      }.to change(@micropost.bads, :count).by(-1)
    end

  end
end
