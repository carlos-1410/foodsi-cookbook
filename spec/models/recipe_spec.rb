require 'rails_helper'

RSpec.describe Recipe, type: :model do
  describe "validations" do
    subject { build(:recipe) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(100).is_at_least(3) }

    it { should validate_presence_of(:text) }
    it { should validate_length_of(:text).is_at_most(1000).is_at_least(10) }

    it { should validate_presence_of(:preparation_time) }
    it { should validate_numericality_of(:preparation_time).only_integer.is_greater_than(0) }
  end

  describe "enums" do
    it do
      should define_enum_for(:difficulty)
        .with_values(easy: 0, medium: 1, hard: 2, expert: 3)
        .backed_by_column_of_type(:integer)
    end
  end

  describe "associations" do
    it { should belong_to(:author) }

    it { should have_many(:recipe_categories).dependent(:destroy) }
    it { should have_many(:categories).through(:recipe_categories) }

    it { should have_many(:likes).dependent(:destroy) }
    it { should have_many(:liked_users).through(:likes).source(:user) }
  end

  describe ".featured" do
    let!(:featured_recipe) { create(:recipe, featured: true) }
    let!(:regular_recipe)  { create(:recipe, featured: false) }

    it "returns only featured recipes" do
      expect(Recipe.featured).to include(featured_recipe)
      expect(Recipe.featured).not_to include(regular_recipe)
    end
  end

  describe "#likes_count" do
    let(:recipe) { create(:recipe) }

    before do
      create_list(:like, 3, recipe: recipe)
    end

    it "returns the number of likes" do
      expect(recipe.likes_count).to eq(3)
    end
  end
end
