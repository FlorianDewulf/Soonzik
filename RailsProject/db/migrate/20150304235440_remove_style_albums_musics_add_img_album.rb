class RemoveStyleAlbumsMusicsAddImgAlbum < ActiveRecord::Migration
  def change
  	create_table :albums_genres, id: false do |t|
      t.integer :album_id, :null => false
      t.integer :genre_id, :null => false
    end
		rename_column :albums, :style, :image
    remove_column :musics, :style
    remove_column :packs, :style
  end
end
