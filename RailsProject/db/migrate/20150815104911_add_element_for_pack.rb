class AddElementForPack < ActiveRecord::Migration
  def change
  	add_column :packs, :begin_date, :datetime, :null => false, default: Time.now
  	add_column :packs, :end_date, :datetime, :null => false, default: Time.now
  	add_column :packs, :minimal_price, :float, :null => false, default: 1
  end
end
