require 'rails_helper'

RSpec.describe "search_types/show", type: :view do
  before(:each) do
    assign(:search_type, SearchType.create!(
      search_type_id: 2,
      search_type_content: "Search Type Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Search Type Content/)
  end
end
