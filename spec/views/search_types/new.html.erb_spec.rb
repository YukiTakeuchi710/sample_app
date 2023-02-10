require 'rails_helper'

RSpec.describe "search_types/new", type: :view do
  before(:each) do
    assign(:search_type, SearchType.new(
      search_type_id: 1,
      search_type_content: "MyString"
    ))
  end

  it "renders new search_type form" do
    render

    assert_select "form[action=?][method=?]", search_types_path, "post" do

      assert_select "input[name=?]", "search_type[search_type_id]"

      assert_select "input[name=?]", "search_type[search_type_content]"
    end
  end
end
