class NewTableGenresMusics < ActiveRecord::Migration
  def change
  	create_table :genres_musics, id: false do |t|
      t.integer :genre_id, :null => false
      t.integer :music_id, :null => false
    end
  end
end
