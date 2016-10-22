class CreateMusicNotes < ActiveRecord::Migration
  def change
    create_table :music_notes do |t|
      t.integer :user_id, :null => false
      t.integer :music_id, :null => false
      t.integer :value, :null => false

      t.timestamps
    end
  end
end
