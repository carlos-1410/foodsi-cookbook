class AssociateRecipeWithAuthor < ActiveRecord::Migration[7.0]
  def change
    add_reference :recipes, :author, foreign_key: true
  end
end
