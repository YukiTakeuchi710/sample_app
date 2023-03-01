# == Schema Information
#
# Table name: mutes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  muted_id   :integer
#  muter_id   :integer
#
require 'rails_helper'

RSpec.describe Mute, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
  end

  # 通常ルートの
  it "is valid creation" do
    Mute.create(muter_id: @user.id, muted_id: @other_user.id).valid?
  end

  # ミュートユーザーIDはnilだと動かない
  it "is invalid creation without muter_id" do
    !Mute.create(muter_id: nil, muted_id: @other_user.id).valid?
  end
  # ミュートされたIDがnilだと動かない
  it "is invalid creation without muted_id" do
    !Mute.create(muter_id: @user.id, muted_id: nil).valid?
  end
end
