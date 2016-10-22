class DistinctPartialAlbum < ActiveRecord::Migration
  def change
  	create_table :partial_albums do |t|
      t.integer :pack_id, :null => false
      t.integer :album_id, :null => false

      t.timestamps
    end
  end
end
