class AddPackGift < ActiveRecord::Migration
  def change
  	add_column :purchased_packs, :gift_user_id, :integer
  end
end
