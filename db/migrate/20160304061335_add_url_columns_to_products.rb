class AddUrlColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :url, :string, default: ""
  end
end
