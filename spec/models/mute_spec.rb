# == Schema Information
#
# Table name: mutes
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  muted_id   :integer
#  muter_id   :integer
#
require 'rails_helper'

RSpec.describe Mute, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
