require 'rails_helper'

RSpec.describe "micropost_ranges/show", type: :view do
  before(:each) do
    assign(:micropost_range, MicropostRange.create!(
      range_id: 2,
      range_content: "Range Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Range Content/)
  end
end
