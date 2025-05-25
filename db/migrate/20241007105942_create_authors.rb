class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :bio
      t.string :fb
      t.string :ig

      t.timestamps
    end
  end
end
