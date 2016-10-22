class CreateAlbumNotes < ActiveRecord::Migration
  def change
    create_table :album_notes do |t|
      t.integer :user_id, :null => false
      t.integer :album_id, :null => false
      t.integer :value, :null => false

      t.timestamps
    end
  end
end
