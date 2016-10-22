class FeedbackTable < ActiveRecord::Migration
  def change
  	create_table :feedbacks do |t|
      t.string :email, :null => false
      t.integer :user_id
      t.string :type_object, :null => false
      t.string :object, :null => false
      t.string :text, :null => false

      t.timestamps
    end
  end
end
