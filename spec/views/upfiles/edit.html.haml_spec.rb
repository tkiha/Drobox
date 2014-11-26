require 'rails_helper'

RSpec.describe "upfiles/edit", :type => :view do
  before(:each) do
    @upfile = assign(:upfile, Upfile.create!())
  end

  it "renders the edit upfile form" do
    render

    assert_select "form[action=?][method=?]", upfile_path(@upfile), "post" do
    end
  end
end
