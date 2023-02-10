require 'rails_helper'

RSpec.describe "search_types/edit", type: :view do
  let(:search_type) {
    SearchType.create!(
      search_type_id: 1,
      search_type_content: "MyString"
    )
  }

  before(:each) do
    assign(:search_type, search_type)
  end

  it "renders the edit search_type form" do
    render

    assert_select "form[action=?][method=?]", search_type_path(search_type), "post" do

      assert_select "input[name=?]", "search_type[search_type_id]"

      assert_select "input[name=?]", "search_type[search_type_content]"
    end
  end
end
