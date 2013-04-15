require 'spec_helper'

describe HomeController do
  describe "GET index" do
    it "has a 200 status code" do
      get :index
      response.should be_success
    end
  end
end
