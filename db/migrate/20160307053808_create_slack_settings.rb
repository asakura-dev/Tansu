class CreateSlackSettings < ActiveRecord::Migration
  def change
    create_table :slack_settings do |t|
      t.text :data
      t.timestamps null: false
    end
  end
end
