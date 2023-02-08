require 'rails_helper'

RSpec.describe "micropost_ranges/new", type: :view do
  before(:each) do
    assign(:micropost_range, MicropostRange.new(
      range_id: 1,
      range_content: "MyString"
    ))
  end

  it "renders new micropost_range form" do
    render

    assert_select "form[action=?][method=?]", micropost_ranges_path, "post" do

      assert_select "input[name=?]", "micropost_range[range_id]"

      assert_select "input[name=?]", "micropost_range[range_content]"
    end
  end
end
