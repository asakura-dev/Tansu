class AddUrlColumnsToProducts < ActiveRecord::Migration[4.2]
  def change
    add_column :products, :url, :string, default: ""
  end
end
