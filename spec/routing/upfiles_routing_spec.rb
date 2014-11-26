require "rails_helper"

RSpec.describe UpfilesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/upfiles").to route_to("upfiles#index")
    end

    it "routes to #new" do
      expect(:get => "/upfiles/new").to route_to("upfiles#new")
    end

    it "routes to #show" do
      expect(:get => "/upfiles/1").to route_to("upfiles#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/upfiles/1/edit").to route_to("upfiles#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/upfiles").to route_to("upfiles#create")
    end

    it "routes to #update" do
      expect(:put => "/upfiles/1").to route_to("upfiles#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/upfiles/1").to route_to("upfiles#destroy", :id => "1")
    end

  end
end
