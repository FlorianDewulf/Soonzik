class CreatePropositions < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.integer :artist_id, :null => false
      t.integer :album_id, :null => false
      t.integer :state, :null => false
      t.datetime :date_posted, :null => false

      t.timestamps
    end
  end
end
