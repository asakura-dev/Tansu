class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.integer :product_id
      t.integer :user_id
      t.text :content
      t.timestamps
    end
    add_index :comments, [:product_id, :user_id]
  end
end
