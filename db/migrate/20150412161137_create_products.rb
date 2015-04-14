class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false, default: ""
      t.text :description
      t.string :image
      t.integer :count
      t.string :status

      t.timestamps
    end
  end
end
