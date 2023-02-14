# == Schema Information
#
# Table name: bads
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  micropost_id :integer
#  user_id      :integer
#
require 'rails_helper'

RSpec.describe Bad, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @Micropost = FactoryBot.create(:micropost)
  end

  # 通常ルートの
  it "is valid creation" do
    Bad.create(user_id: @user.id, micropost_id: @Micropost.id).valid?
  end
  # LikeユーザーIDがnilだと作成できない
  it "is invalid creation without muter_id" do
    !Bad.create(user_id: nil, micropost_id: @Micropost.id).valid?
  end
  # MicropostIDがnilだと作成できない
  it "is invalid creation without muted_id" do
    !Bad.create(user_id: @user.id, micropost_id: nil).valid?
    end
end
