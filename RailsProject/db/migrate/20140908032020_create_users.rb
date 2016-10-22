class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null => false
      t.string :password, :null => false
      t.string :salt, :null => false
      t.string :fname
      t.string :lname
      t.string :username, :null => false
      t.date :birthday, :null => false
      t.string :image, :null => false
      t.text :description
      t.string :phoneNumber
      t.integer :adress_id
      t.string :facebook
      t.string :twitter
      t.string :googlePlus
      t.datetime :signin, :null => false
      t.string :idAPI, :null => false
      t.string :secureKey, :null => false
      t.boolean :activated, :null => false
      t.boolean :newsletter, :null => false
      t.string :language, :null => false

      t.timestamps
    end
  end
end
