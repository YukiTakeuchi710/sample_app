# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  activation_digest :string
#  admin             :boolean
#  email             :string
#  name              :string
#  password_digest   :string
#  remember_digest   :string
#  reset_digest      :string
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  #let(:user) {FactoryBot.create(:user)}
  before do
    @user = FactoryBot.create(:user)
  end

  it  "is valid with a name email, password, admin, active, " do
    #user = FactoryBot.create(:user)
    @user.valid?
  end
  #it { is_expected.to validate_presence_of :name}

  # name:名前
  #   必須
  #   nilの場合失敗
  it "is invalid without name" do
    nameless = FactoryBot.build(:user, name: nil)
    expect(nameless).to_not be_valid
  end
  #   最大50文字の制約
  #
  it "is valid name in 50 " do
    limit_long_name = "a" * 50
    user = FactoryBot.build(:user, name: limit_long_name)
    expect(user).to be_valid
  end

  # 50文字オーバー
  it "is valid name over 50" do
    too_long_name = "a" * 51
    user = FactoryBot.build(:user, name: too_long_name)
    expect(user).to_not be_valid
  end

  # 全角換算
  # 50文字オーバー
  it "is valid name in full-with 50" do
    limit_long_name = "あ" * 50
    user = FactoryBot.build(:user, name: limit_long_name)
    expect(user).to be_valid
  end

  # 50文字オーバー
  it "is valid name over full-with 50" do
    too_long_name = "a" * 51
    user = FactoryBot.build(:user, name: too_long_name)
    expect(user).to_not be_valid
  end
  # email:メールアドレス
  #   必須
  it "is invalid without email" do
    user = FactoryBot.build(:user, email: nil)
    expect(user).to_not be_valid
  end
  #   メール構文@などが必要
  #   @をとる
  it "is invalid out of email format" do
    user = FactoryBot.build(:user, email: 'testerexample.com')
    expect(user).to_not be_valid
  end
  #   必ず小文字になっていること。(大文字に置き換えてもパスする)⇒インテグレーションテストでやるのがよし
  #it "is invalid out of email format" do
  #  user = FactoryBot.build(:user, email: 'LARGERCASE@EXAMPLE.COM')
  #  expect(user.email).to eq "LARGERCASE@EXAMPLE.COM".downcase
  #end

  # パスワード

  #   nilでは通らない
  it "is valid without password" do
    user = FactoryBot.build(:user, password: nil)
    expect(user).to_not be_valid
  end
  #   最低6文字以上(5文字で失敗)
  it "is invalid less than 6 chars" do
    user = FactoryBot.build(:user, password: 'abcde')
    expect(user).to_not be_valid
  end
  # 管理者権限:
  #
  # userは複数のmicropostを持つことができる
  # active_relationshipsを持つことで、
end
