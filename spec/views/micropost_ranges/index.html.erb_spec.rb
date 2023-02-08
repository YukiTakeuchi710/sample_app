require 'rails_helper'

RSpec.describe "micropost_ranges/index", type: :view do
  before(:each) do
    assign(:micropost_ranges, [
      MicropostRange.create!(
        range_id: 2,
        range_content: "Range Content"
      ),
      MicropostRange.create!(
        range_id: 2,
        range_content: "Range Content"
      )
    ])
  end

  it "renders a list of micropost_ranges" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Range Content".to_s), count: 2
  end
end
