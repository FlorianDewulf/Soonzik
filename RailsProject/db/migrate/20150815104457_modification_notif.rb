class ModificationNotif < ActiveRecord::Migration
  def change
  	rename_column :notifications, :link, :notif_type

  	remove_column :notifications, :description
    add_column :notifications, :from_user_id, :integer, :null => false, default: 1
    add_column :notifications, :read, :boolean, :null => false, default: false
  end
end
