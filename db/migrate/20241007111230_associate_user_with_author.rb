class AssociateUserWithAuthor < ActiveRecord::Migration[7.0]
  def change
    add_reference :authors, :user, foreign_key: true
  end
end
