# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
  end

  # 通常ルートの
  it "is valid creation" do
    Relationship.create(follower_id: @user.id, followed_id: @other_user.id).valid?
  end

  # ミュートユーザーIDはnilだと動かない
  it "is invalid creation without muter_id" do
    !Relationship.create(follower_id: nil, followed_id: @other_user.id).valid?
  end
  # ミュートされたIDがnilだと動かない
  it "is invalid creation without muted_id" do
    !Relationship.create(follower_id: @user.id, followed_id: nil).valid?
    end
end
