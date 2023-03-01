# == Schema Information
#
# Table name: search_types
#
#  id                  :bigint           not null, primary key
#  search_type_content :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  search_type_id      :integer
#
FactoryBot.define do
  factory :search_type_text do
    search_type_id { 1 }
    search_type_content { "MyString" }
  end
  factory :search_type_user do
    search_type_id { 1 }
    search_type_content { "MyString" }
  end
end

