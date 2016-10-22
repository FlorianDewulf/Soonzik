class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.integer :to_user, :null => false
      t.integer :from_user, :null => false
      t.string :typeObj, :null => false
      t.integer :obj_id, :null => false

      t.timestamps
    end
  end
end
