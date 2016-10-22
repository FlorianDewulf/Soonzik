class CreatePacks < ActiveRecord::Migration
  def change
    create_table :packs do |t|
      t.string :title, :null => false
      t.string :style, :null => false

      t.timestamps
    end
  end
end
