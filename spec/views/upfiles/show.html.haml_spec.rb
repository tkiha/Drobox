require 'rails_helper'

RSpec.describe "upfiles/show", :type => :view do
  before(:each) do
    @upfile = assign(:upfile, Upfile.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
