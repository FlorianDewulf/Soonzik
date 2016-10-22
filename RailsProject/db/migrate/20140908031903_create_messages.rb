class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :msg, :null => false
      t.integer :user_id, :null => false
      t.integer :dest_id, :null => false
      t.string :session, :null => false

      t.timestamps
    end
  end
end
