class CreateLendings < ActiveRecord::Migration
  def change
    create_table :lendings do |t|
      t.integer :product_id
      t.integer :user_id
      t.date :deadline
      t.string :status
      t.timestamps
    end
  end
end
