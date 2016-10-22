class ModifyColumnTypeNews < ActiveRecord::Migration
  def change
  	rename_column :news, :type, :news_type
  end
end
