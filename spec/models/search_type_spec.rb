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
require 'rails_helper'

RSpec.describe SearchType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
