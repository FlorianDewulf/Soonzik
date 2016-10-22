class MusicAlbumIdNullable < ActiveRecord::Migration
  def change
  	change_column :musics, :album_id, :boolean, :null => true
  end
end
