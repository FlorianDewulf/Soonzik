class AddRowToMusicsPlaylists < ActiveRecord::Migration
  def change
  	add_column :musics_playlists, :row_order, :integer
  end
end
