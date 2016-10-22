class ListLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :language, :null => false
      t.string :abbreviation, :null => false

      t.timestamps
    end
  end
end
