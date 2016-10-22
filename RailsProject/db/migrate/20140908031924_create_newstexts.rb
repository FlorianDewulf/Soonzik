class CreateNewstexts < ActiveRecord::Migration
  def change
    create_table :newstexts do |t|
      t.text :content, :null => false
      t.string :title, :null => false
      t.string :language, :null => false
      t.integer :news_id, :null => false

      t.timestamps
    end
  end
end
