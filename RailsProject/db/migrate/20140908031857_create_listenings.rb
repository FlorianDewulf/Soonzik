class CreateListenings < ActiveRecord::Migration
  def change
    create_table :listenings do |t|
      t.integer :user_id, :null => false
      t.integer :music_id, :null => false
      t.datetime :when, :null => false
      t.float :latitude, :null => false
      t.float :longitude, :null => false

      t.timestamps
    end
  end
end
