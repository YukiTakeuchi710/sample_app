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
FactoryBot.define do
  factory :like do
    micropost_id { 1 }
    user_id { 1 }
  end
end
