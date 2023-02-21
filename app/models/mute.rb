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
class Mute < ApplicationRecord
  belongs_to :muter, class_name: "User"
  belongs_to :muted, class_name: "User"

  has_many :post_by_muted, class_name: "Microposts" , foreign_key: "user_id", primary_key: "muted_id"
  has_many :post_by_muting, class_name: "Microposts", foreign_key: "user_id", primary_key: "muter_id"

  validates :muter_id, presence: true
  validates :muted_id, presence: true
end
