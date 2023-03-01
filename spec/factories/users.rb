# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  activation_digest :string
#  admin             :boolean
#  email             :string
#  name              :string
#  password_digest   :string
#  remember_digest   :string
#  reset_digest      :string
#  reset_sent_at     :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { 'Michael Example1' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    admin {true}
    activated {true}
    activated_at {Time.zone.now}
  end

  factory :other_user do
    name { 'Michael Example1' }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { 'password' }
    admin {true}
    activated {true}
    activated_at {Time.zone.now}
  end


end
