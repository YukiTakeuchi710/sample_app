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
class Micropost < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
            size:         { less_than: 5.megabytes,
                            message:   "should be less than 5MB" }
  # 検索条件１
  # fullopen:0の場合は
  scope :search, ->(user_id)  {
    query = <<-SQL
      SELECT
        micropost.*
      FROM microposts
      LEFT outer join relationships AS followed_relation on
        :user_id == followed_relation.followed_id
        AND microposts.user_id == followed_relation.follower_id
      LEFT outer join relationships AS following_relation on
        :user_id == following_relation.follower_id
        AND microposts.user_id == following_relation.followed_id
      WHERE 
        microposts.range == 0
        OR (microposts.range == 1 AND followed_relation.id IS NOT NULL )
        OR (microposts.range == 2 AND followed_relation.id IS NOT NULL AND following_relation.id IS NOT NULL )
        OR (microposts.range == 3 AND microposts.user_id == :user_id )
    SQL
    find_by_sql([query,{user_id: user_id} ])
  }
end
