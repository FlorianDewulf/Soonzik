class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, :null => false
      t.integer :battle_id, :null => false
      t.integer :artist_id, :null => false

      t.timestamps
    end
  end
end
