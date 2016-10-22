class CreateCommentaries < ActiveRecord::Migration
  def change
    create_table :commentaries do |t|
      t.integer :author_id, :null => false
      t.text :content, :null => false
      t.datetime :create_at, :null => false

      t.timestamps
    end
  end
end
