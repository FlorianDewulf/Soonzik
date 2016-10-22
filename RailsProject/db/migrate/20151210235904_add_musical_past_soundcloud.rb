class AddMusicalPastSoundcloud < ActiveRecord::Migration
  def change
  	create_table :musicalpasts do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.integer :soundcloud_music_id, :null => false
      t.integer :genre_id, :null => false

      t.timestamps
    end
  end
end
