# == Schema Information
#
# Table name: search_types
#
#  id                  :integer          not null, primary key
#  search_type_content :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  search_type_id      :integer
#
class SearchType < ApplicationRecord
  # 定数を書いておく
  # 検索タイプ：投稿
  SEARCH_TYPE_MICROPOST = "1"
  # 検索タイプ：ユーザ名
  SEARCH_TYPE_USER = "2"
end
