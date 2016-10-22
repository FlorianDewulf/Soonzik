class CreateInfluences < ActiveRecord::Migration
  def change
    create_table :influences do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
