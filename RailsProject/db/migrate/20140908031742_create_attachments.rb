class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :url, :null => false
      t.integer :file_size, :null => false
      t.string :content_type, :null => false

      t.timestamps
    end
  end
end
