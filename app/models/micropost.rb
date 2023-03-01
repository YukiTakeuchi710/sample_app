# == Schema Information
#
# Table name: microposts
#
#  id         :bigint           not null, primary key
#  content    :text
#  range      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_microposts_on_user_id                 (user_id)
#  index_microposts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Micropost < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  has_many :likes, dependent: :destroy
  has_many :bads, dependent: :destroy

  has_many :liked_users, through: :likes, source: :user
  has_many :bad_users, through: :bads, source: :user


  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  has_one :followed_post , class_name: "Relationship", foreign_key: "follower_id", primary_key: "user_id"
  has_one :following_post, class_name: "Relationship", foreign_key: "followed_id", primary_key: "user_id"

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
            size:         { less_than: 5.megabytes,
                            message:   "should be less than 5MB" }

  # likeを追加する。
  def like(user)
    likes.create(user_id: user.id)
  end

  # likeを解除する
  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  # likeをつけているかどうか？
  def liked?(user)
    liked_users.include?(user)
  end

  # badを追加
  def bad(user)
    bads.create(user_id: user.id)
  end
  # badを解除
  def unbad(user)
    bads.find_by(user_id: user.id).destroy
  end
  # badをつけているかどうか
  def bad?(user)
    bad_users.include?(user)
  end
end

