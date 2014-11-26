require 'rails_helper'

RSpec.describe "Upfiles", :type => :request do
  describe "GET /upfiles" do
    it "works! (now write some real specs)" do
      get upfiles_path
      expect(response).to have_http_status(200)
    end
  end
end
