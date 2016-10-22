class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.integer :user_id, :null => false
      t.datetime :planification, :null => false
      t.integer :address_id, :null => false
      t.string :url

      t.timestamps
    end
  end
end
