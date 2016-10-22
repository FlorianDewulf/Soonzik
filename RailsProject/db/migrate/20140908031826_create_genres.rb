class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :style_name, :null => false
      t.string :color_name, :null => false
      t.string :color_hexa, :null => false

      t.timestamps
    end
  end
end
