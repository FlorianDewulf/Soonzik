class ModificationGiftType < ActiveRecord::Migration
  def change
  	remove_column :carts, :gift_id
    add_column :carts, :gift_id, :integer, :null => true, default: nil
  end
end
