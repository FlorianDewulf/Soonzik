class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text :msg, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end
end
