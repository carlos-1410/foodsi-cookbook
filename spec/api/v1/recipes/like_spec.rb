require 'rails_helper'

RSpec.describe "recipes#like", type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  
  subject(:make_request) do
    post "/api/v1/recipes/#{recipe.id}/like", headers: auth_headers(user)
  end

  it "likes the recipe" do
    make_request
    expect(response).to have_http_status(:success)
    expect(recipe.likes.count).to eq(1)
  end
end
