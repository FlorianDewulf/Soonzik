class CreateNewsletter < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|
    	t.string :obj_msg
    	t.string :html_content
    end
  end
end
