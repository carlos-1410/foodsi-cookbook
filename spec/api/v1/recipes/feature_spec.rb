require 'rails_helper'

RSpec.describe "recipes#feature", type: :request do
  let(:user) { create(:user, :with_author) }
  let(:recipe) { create(:recipe, author: user.author) }

  subject(:make_request) do
    put "/api/v1/recipes/#{recipe.id}/feature", headers: auth_headers(user)
  end

  it "toggles featured status" do
    make_request
    expect(response).to have_http_status(:success)
  end
end
