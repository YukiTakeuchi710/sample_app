require 'rails_helper'

RSpec.describe "micropost_ranges/edit", type: :view do
  let(:micropost_range) {
    MicropostRange.create!(
      range_id: 1,
      range_content: "MyString"
    )
  }

  before(:each) do
    assign(:micropost_range, micropost_range)
  end

  it "renders the edit micropost_range form" do
    render

    assert_select "form[action=?][method=?]", micropost_range_path(micropost_range), "post" do

      assert_select "input[name=?]", "micropost_range[range_id]"

      assert_select "input[name=?]", "micropost_range[range_content]"
    end
  end
end
