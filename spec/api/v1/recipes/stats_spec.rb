require 'rails_helper'

RSpec.describe "recipes#stats", type: :request do
  let(:user) { create(:user, :with_author) }

  it "returns recipe stats and calls the Recipes::Stats service" do
    allow(Recipes::Stats).to receive(:call).and_return([])

    get "/api/v1/recipes/stats", params: {
      group_by: "month",
      created_after: "2024-01-01",
      created_before: "2024-12-31"
    }, headers: auth_headers(user)

    expect(response).to have_http_status(:ok)
    expect(Recipes::Stats).to have_received(:call).with(
      hash_including(
        author: user.author,
        group_by: "month",
        created_after: "2024-01-01",
        created_before: "2024-12-31"
      )
    )
  end
end
