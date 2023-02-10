require 'rails_helper'

RSpec.describe "search_types/index", type: :view do
  before(:each) do
    assign(:search_types, [
      SearchType.create!(
        search_type_id: 2,
        search_type_content: "Search Type Content"
      ),
      SearchType.create!(
        search_type_id: 2,
        search_type_content: "Search Type Content"
      )
    ])
  end

  it "renders a list of search_types" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Search Type Content".to_s), count: 2
  end
end
