class AddRelationToOrderPlaylist < ActiveRecord::Migration
  def change
  	rename_table :musics_playlists, :playlist_objects
  	create_table :musics_playlist_objects, id: false do |t|
      t.integer :music_id, :null => false
      t.integer :playlist_object_id, :null => false
    end
  end
end
