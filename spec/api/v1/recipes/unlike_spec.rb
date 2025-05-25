require 'rails_helper'

RSpec.describe "recipes#unlike", type: :request do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }

  before { recipe.likes.create(user: user) }

  subject(:make_request) do
    post "/api/v1/recipes/#{recipe.id}/unlike", headers: auth_headers(user)
  end

  it "unlikes the recipe" do
    make_request
    expect(response).to have_http_status(:success)
    expect(recipe.likes.count).to eq(0)
  end
end
