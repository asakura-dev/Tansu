class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ""
      t.text :description
      t.string :image

      t.timestamps
    end
    add_index :products, :created_at
  end
end
