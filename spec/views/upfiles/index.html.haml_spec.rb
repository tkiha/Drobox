require 'rails_helper'

RSpec.describe "upfiles/index", :type => :view do
  before(:each) do
    assign(:upfiles, [
      Upfile.create!(),
      Upfile.create!()
    ])
  end

  it "renders a list of upfiles" do
    render
  end
end
