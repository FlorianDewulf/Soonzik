class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id, :null => false
      t.string :link, :null => false
      t.string :description, :null => false

      t.timestamps
    end
  end
end
