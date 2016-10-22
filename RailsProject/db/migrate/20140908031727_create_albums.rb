class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.string :style, :null => false
      t.float :price, :null => false
      t.string :file, :null => false
      t.integer :yearProd, :null => false

      t.timestamps
    end
  end
end
