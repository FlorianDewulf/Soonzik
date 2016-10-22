class CreateBattles < ActiveRecord::Migration
  def change
    create_table :battles do |t|
      t.datetime :date_begin, :null => false
      t.datetime :date_end, :null => false
      t.integer :artist_one_id, :null => false
      t.integer :artist_two_id, :null => false

      t.timestamps
    end
  end
end
