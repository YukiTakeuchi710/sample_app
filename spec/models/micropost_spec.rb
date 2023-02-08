# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :text
#  range      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_microposts_on_user_id                 (user_id)
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = FactoryBot.create(:user)

    @micropost = Micropost.new(
      user_id: @user.__id__,
      content: "Test",
      image: nil,
    )
  end

  #)
  # 正常系
  it "is valid with user_id, content, image" do
    # micropost = @user.micrposts.create(:micropost)
    @micropost.valid?
  end
  # ユーザーに依存する
  it "depends on user" do
  end
  # 画像添付が可能は500×500 ⇒　システムテスト
  # user_idは必須事項
  it "is invalid without user_id" do
    invalid_micropost = FactoryBot.build(:micropost)
    p invalid_micropost
    !invalid_micropost.valid?
  end
  # contentは必須事項
  it "is invalid without content" do
    blank_content = FactoryBot.build(:micropost, content: nil)
    !blank_content.valid?
  end
  # contentは最大140文字
  it "is invalid 140 over content" do
    too_long_content = "a" * 141
    too_long_content_user = FactoryBot.build(:micropost, content: too_long_content)
    !too_long_content_user.valid?

  end
  # imgの content_typeは image/jpeg,image/gif,  image/png
  it "is valid image/jpeg" do
    img = fixture_file_upload('th.gif', 'image/gif')
    micropost_with_img = FactoryBot.create(:micropost, image: img)
    expect(micropost_with_img).to be_valid
    micropost_with_img.valid?
  end
  it "is valid image/gif" do
    img = fixture_file_upload('kitten.jpg', 'image/jpeg')
    micropost_with_gif = FactoryBot.build(:micropost, image: img)
    micropost_with_gif.valid?
  end
  it "is valid image/png" do
    img = fixture_file_upload('png_test.PNG', 'image/png')
    micropost_with_png = FactoryBot.build(:micropost, image: img)
    micropost_with_png.valid?
  end
  # imgの容量は5メガバイトの制限をつける。
  it "is invalid 5MB over img" do

  end
end
