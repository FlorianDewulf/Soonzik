class ReworkPurchase < ActiveRecord::Migration
  def change
  	drop_table :albums_purchases
  	drop_table :musics_purchases
  	drop_table :packs_purchases

  	create_table :purchasedAlbums do |t|
      t.integer :album_id, :null => false
      t.integer :purchased_pack_id, :null => true
    end

  	create_table :purchasedMusics do |t|
      t.integer :music_id, :null => false
      t.integer :purchase_id, :null => false
      t.integer :purchased_album_id, :null => true
    end

  	create_table :purchasedPacks do |t|
      t.integer :pack_id, :null => false
      t.boolean :partial, :null => false
    end
  end
end
