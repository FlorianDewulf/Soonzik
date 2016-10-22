class AddFieldToPack < ActiveRecord::Migration
  def change
  	add_column :packs, :association_id, :integer

  	create_table :descriptions_packs do |t|
      t.integer :description_id, :null => false
      t.integer :pack_id, :null => true
    end
  end
end
