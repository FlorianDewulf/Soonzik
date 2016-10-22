class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :user_id, :null => false
      t.string :typeObj, :null => false
      t.integer :obj_id, :null => false
      t.boolean :gift, :null => false

      t.timestamps
    end
  end
end
