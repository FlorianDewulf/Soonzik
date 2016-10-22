class PercentagePack < ActiveRecord::Migration
  def change
  	add_column :purchased_packs, :artist_percentage, :integer
  	add_column :purchased_packs, :association_percentage, :integer
  	add_column :purchased_packs, :website_percentage, :integer
  	add_column :purchased_packs, :value, :integer
  end
end
