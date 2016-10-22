class ModificationGift < ActiveRecord::Migration
  def change
  	rename_column :carts, :gift, :gift_id
  end
end
