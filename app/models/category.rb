class Category < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100, minimum: 3 }

  enum :group, {
    diet: :diet,
    cuisine: :cuisine,
    dish_type: :dish_type,
    occasion: :occasion
  }

  has_many :recipe_categories, dependent: :destroy
  has_many :recipes, through: :recipe_categories
end
