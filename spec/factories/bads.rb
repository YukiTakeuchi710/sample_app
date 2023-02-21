# == Schema Information
#
# Table name: bads
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  micropost_id :integer
#  user_id      :integer
#
FactoryBot.define do
  factory :bad do
    micropost_id { 1 }
    user_id { 1 }
  end
end
