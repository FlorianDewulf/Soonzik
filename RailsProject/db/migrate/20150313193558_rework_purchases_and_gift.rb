class ReworkPurchasesAndGift < ActiveRecord::Migration
  def change
  	#
  	# Modification for purchase table
  	#
  	create_table :albums_purchases, id: false do |t|
      t.integer :album_id, :null => false
      t.integer :purchase_id, :null => false
    end

  	create_table :musics_purchases, id: false do |t|
      t.integer :music_id, :null => false
      t.integer :purchase_id, :null => false
    end

  	create_table :packs_purchases, id: false do |t|
      t.integer :pack_id, :null => false
      t.integer :purchase_id, :null => false
    end

    remove_column :purchases, :typeObj
    remove_column :purchases, :obj_id
    remove_column :purchases, :date

  	#
  	# Modification for gift table
  	#
  	create_table :albums_gifts, id: false do |t|
      t.integer :album_id, :null => false
      t.integer :gift_id, :null => false
    end

  	create_table :gifts_musics, id: false do |t|
      t.integer :music_id, :null => false
      t.integer :gift_id, :null => false
    end

  	create_table :gifts_packs, id: false do |t|
      t.integer :pack_id, :null => false
      t.integer :gift_id, :null => false
    end

    remove_column :gifts, :typeObj
    remove_column :gifts, :obj_id

  	#
  	# Modification for cart table
  	#
  	create_table :albums_carts, id: false do |t|
      t.integer :album_id, :null => false
      t.integer :cart_id, :null => false
    end

  	create_table :carts_musics, id: false do |t|
      t.integer :music_id, :null => false
      t.integer :cart_id, :null => false
    end

  	create_table :carts_packs, id: false do |t|
      t.integer :pack_id, :null => false
      t.integer :cart_id, :null => false
    end

    remove_column :carts, :typeObj
    remove_column :carts, :obj_id

  end
end
