# == Schema Information
#
# Table name: likes
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  micropost_id :integer
#  user_id      :integer
#
class Like < ApplicationRecord

  has_one :user, foreign_key: :id, primary_key: :user_id
  has_one :micropost, foreign_key: :id, primary_key: :micropost_id

  validates :user_id, presence: true
  validates :micropost_id, presence: true
end
