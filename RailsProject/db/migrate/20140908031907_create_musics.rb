class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.integer :user_id, :null => false
      t.integer :album_id, :null => false
      t.string :title, :null => false
      t.integer :duration, :null => false
      t.string :style, :null => false
      t.float :price, :null => false
      t.string :file, :null => false
      t.boolean :limited, :null => false

      t.timestamps
    end
  end
end
