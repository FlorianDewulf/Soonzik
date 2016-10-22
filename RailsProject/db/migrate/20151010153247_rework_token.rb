class ReworkToken < ActiveRecord::Migration
  def change
  	add_column :users, :token_update, :datetime, null: false, default: Time.now
  end
end
