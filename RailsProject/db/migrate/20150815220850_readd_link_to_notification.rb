class ReaddLinkToNotification < ActiveRecord::Migration
  def change
  	add_column :notifications, :link, :string, :null => false, default: ""
  end
end
