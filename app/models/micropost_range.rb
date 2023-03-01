# == Schema Information
#
# Table name: micropost_ranges
#
#  id            :bigint           not null, primary key
#  range_content :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  range_id      :integer
#
class MicropostRange < ApplicationRecord
end
