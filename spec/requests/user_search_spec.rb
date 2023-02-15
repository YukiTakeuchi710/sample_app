require 'rails_helper'

RSpec.describe "UserSearches", type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  it "all found" do
    sign_in @user
    get search_user_path, params: { user_name: "" }
    expect(response).to have_http_status(200)
  end

end
