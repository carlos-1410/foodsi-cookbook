class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :text
      t.integer :difficulty
      t.integer :preparation_time

      t.timestamps
    end
  end
end
