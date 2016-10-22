class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :tag, :null => false
      t.integer :news_id, :null => false

      t.timestamps
    end
  end
end
