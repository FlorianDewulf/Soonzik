class Cleandatabase < ActiveRecord::Migration
  def change
  	drop_table :accesses
  	drop_table :album_notes
  	drop_table :albums_gifts
  	drop_table :carts_packs
  	drop_table :descriptions_genres
  	drop_table :descriptions_influences
  	drop_table :descriptions_musics
  	drop_table :flacs
  	drop_table :gifts
  	drop_table :gifts_musics
  	drop_table :gifts_packs
  	drop_table :tags

  	remove_column :carts, :gift_id
  	remove_column :news, :date
  end
end
