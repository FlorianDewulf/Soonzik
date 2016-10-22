class RenameNewTables < ActiveRecord::Migration
  def change
  	rename_table :purchasedAlbums, :purchased_albums
  	rename_table :purchasedMusics, :purchased_musics
  	rename_table :purchasedPacks, :purchased_packs
  end
end
