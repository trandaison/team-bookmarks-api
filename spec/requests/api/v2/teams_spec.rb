require 'rails_helper'

RSpec.describe "Api::V2::Teams", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/api/v2/teams/create"
      expect(response).to have_http_status(:success)
    end
  end

end
