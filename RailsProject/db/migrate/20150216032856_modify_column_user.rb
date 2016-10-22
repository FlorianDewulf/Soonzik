class ModifyColumnUser < ActiveRecord::Migration
  def change
  	rename_column :users, :adress_id, :address_id
  end
end
