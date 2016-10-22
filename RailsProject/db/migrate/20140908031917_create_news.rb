class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title, :null => false
      t.datetime :date, :null => false
      t.integer :author_id, :null => false

      t.timestamps
    end
  end
end
