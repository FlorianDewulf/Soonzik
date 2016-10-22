class PatchBullshitAlbum < ActiveRecord::Migration
  def change
  	change_column :musics, :album_id, :integer, :null => true
  end
end
