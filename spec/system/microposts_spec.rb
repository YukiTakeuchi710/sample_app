require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  include LoginSupport
  #let(:user) {FactoryBot.create(:user)}
  before do
    driven_by(:rack_test)
  end

  scenario "user creates a new Micropost" do

    user = FactoryBot.create(:user)
    go_to_micropost(user)
    # 入力
    expect {
      create_micropost("test")
      # メッセージが表示されることを確認
      expect(page).to have_content "Micropost created!"
      # 投稿が増えることを確認
    }.to change(user.microposts, :count).by(1)
  end
  # 140文字入れたらどうなるか
  scenario "create limit length micropost." do
    user = FactoryBot.create(:user)
    limit_length_mixropost = "あ" * 140
    go_to_micropost(user)
    # 入力
    expect {
      create_micropost(limit_length_mixropost)
      # エラーメッセージが表示されることを確認
      expect(page).to have_content "Micropost created!"
      # 投稿が増えることを確認
    }.to change(user.microposts, :count).by(1)
  end

  # 141文字入れたら失敗する
  scenario "Attempt create too long micropost error." do
    user = FactoryBot.create(:user)
    too_long_mixropost = "あ" * 141
    go_to_micropost(user)
    # 入力
    expect {
      create_micropost(too_long_mixropost)
      # エラーメッセージが表示されることを確認
      expect(page).to have_content "The form contains 1 error."
      # 投稿が増えることを確認
    }.to_not change(user.microposts, :count)
  end

  # 投稿を削除する。
  scenario "delete micropost" do
    user = FactoryBot.create(:user)
    go_to_micropost(user)
    aggregate_failures do
    # 入力
    expect {
      create_micropost("test")
      # メッセージが表示されることを確認
      expect(page).to have_content "Micropost created!"
      # 投稿が増えることを確認
    }.to change(user.microposts, :count).by(1)
    # 削除を行う。
    expect {
      click_link "delete"
      expect(page).to have_content "Micropost deleted"
    }.to change(user.microposts, :count).by(-1)
    end
  end

  # 投稿検索のシナリオ
  #
  # 投稿内容の検索
  scenario "search micropost by content" do
    common_content = "SEARCH_CONTENT"
    user = FactoryBot.create(:user)
    go_to_micropost(user)
    # 3件作成する。
    (1..3).each do |n|
      create_micropost(common_content + n.to_s)
    end
    expect {
      search_micropost_by_content(common_content)
      (1..3).each do |n|
        expect(page).to have_content (common_content + n.to_s)
      end
    }
  end

  # 投稿内容の検索
  scenario "search micropost by content" do
    common_content = "SEARCH_CONTENT"
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)

    go_to_micropost(user)
    # 3件作成する。
    (1..3).each do |n|
      create_micropost(common_content + n.to_s)
    end
    click_link 'Account'
    click_link 'Log out'

    go_to_micropost(other_user)
    other_user_content = "OTHER_USER_CONTENT"
    create_micropost(other_user_content)

    expect {
      search_micropost_by_user_name(user.name)
      (1..3).each do |n|
        expect(page).to have_content (common_content + n.to_s)
      end
      !expect(page).to have_content other_user_content
    }
  end

  # 投稿ページに行くメソッド
  # Arg: User
  def go_to_micropost(user)
    sign_in_as user
    click_link "Home"
  end

  # HOMEで投稿を行う。
  # Arg: String
  def create_micropost(micropost)
    fill_in "micropost_content", with: micropost
    click_button "Post"
  end

  def search_micropost_by_content(micropost_content)
    fill_in "search_content", with: micropost_content
    click_button "Search"
  end

  def search_micropost_by_user_name(user_name)
    select 'ユーザー', from: 'Search type'
    fill_in "search_content", with: user_name
    click_button "Search"
  end

end
