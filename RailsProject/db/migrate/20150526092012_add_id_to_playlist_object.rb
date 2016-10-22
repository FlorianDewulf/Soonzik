class AddIdToPlaylistObject < ActiveRecord::Migration
  def change
  	add_column :musics_playlists, :id, :primary_key
  	change_column :musics_playlists, :row_order, :integer, :default => 1
  end
end
