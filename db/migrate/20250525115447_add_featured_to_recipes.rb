class AddFeaturedToRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :recipes, :featured, :boolean
  end
end
