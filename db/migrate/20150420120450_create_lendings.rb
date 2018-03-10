class CreateLendings < ActiveRecord::Migration[4.2]
  def change
    create_table :lendings do |t|
      t.integer :product_id
      t.integer :user_id
      t.date :deadline
      t.string :status
      t.timestamps
    end
    add_index :lendings, [:product_id, :user_id]
  end
end
