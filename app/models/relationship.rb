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
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  has_many :post_by_followed, class_name: "Microposts" , foreign_key: "user_id", primary_key: "followed_id"
  has_many :post_by_following, class_name: "Microposts", foreign_key: "user_id", primary_key: "follower_id"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
