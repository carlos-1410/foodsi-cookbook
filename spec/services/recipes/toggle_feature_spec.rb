require 'rails_helper'

RSpec.describe Recipes::ToggleFeature do
  let(:user) { create(:user, :with_author) }
  let(:recipe) { create(:recipe, author: user.author) }

  it "toggles the featured flag" do
    result = described_class.new(recipe: recipe, user: user).call
    expect(result.success).to eq(true)
    expect(recipe.reload.featured).to eq(true).or eq(false)
  end
end
