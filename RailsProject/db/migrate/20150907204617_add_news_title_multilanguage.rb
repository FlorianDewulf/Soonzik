class AddNewsTitleMultilanguage < ActiveRecord::Migration
  def change
  	remove_column :news, :title
  	remove_column :news, :news_type

  	create_table(:news_titles) do |t|
      t.integer :news_id, null: false
      t.string :title, null: false, default: "No Title"
      t.string :language, null: false, default: "EN"
    end
  end
end
