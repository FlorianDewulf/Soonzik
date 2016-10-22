class CreateDescriptions < ActiveRecord::Migration
  def change
    create_table :descriptions do |t|
      t.text :description, :null => false
      t.string :language, :null => false

      t.timestamps
    end
  end
end
