class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :user_id, :null => false
      t.string :typeObj, :null => false
      t.integer :obj_id, :null => false
      t.datetime :date, :null => false

      t.timestamps
    end
  end
end
