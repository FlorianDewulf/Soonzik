class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.integer :group_id, :null => false
      t.string :controllerName, :null => false
      t.string :actionName, :null => false

      t.timestamps
    end
  end
end
