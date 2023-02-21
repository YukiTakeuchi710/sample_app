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
FactoryBot.define do
  factory :mute do
    muter_id { 1 }
    muted_id { 1 }
  end
end
