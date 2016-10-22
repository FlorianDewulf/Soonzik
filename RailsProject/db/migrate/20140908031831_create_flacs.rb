class CreateFlacs < ActiveRecord::Migration
  def change
    create_table :flacs do |t|
      t.integer :music_id, :null => false
      t.string :file, :null => false

      t.timestamps
    end
  end
end
