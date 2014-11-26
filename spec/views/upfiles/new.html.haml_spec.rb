require 'rails_helper'

RSpec.describe "upfiles/new", :type => :view do
  before(:each) do
    assign(:upfile, Upfile.new())
  end

  it "renders new upfile form" do
    render

    assert_select "form[action=?][method=?]", upfiles_path, "post" do
    end
  end
end
