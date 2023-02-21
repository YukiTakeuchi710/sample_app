# == Schema Information
#
# Table name: likes
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  micropost_id :integer
#  user_id      :integer
#
require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @Micropost = FactoryBot.create(:micropost)
  end

  # 通常ルートの
  it "is valid creation" do
    Like.create(user_id: @user.id, micropost_id: @Micropost.id).valid?
  end
  # LikeユーザーIDがnilだと作成できない
  it "is invalid creation without muter_id" do
    !Like.create(user_id: nil, micropost_id: @Micropost.id).valid?
  end
  # MicropostIDがnilだと作成できない
  it "is invalid creation without muted_id" do
    !Like.create(user_id: @user.id, micropost_id: nil).valid?
    end
end
