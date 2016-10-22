class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :numberStreet, :null => false
      t.string :complement
      t.string :street, :null => false
      t.string :city, :null => false
      t.string :country, :null => false
      t.string :zipcode, :null => false

      t.timestamps
    end
  end
end
