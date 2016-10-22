class RemoveUselessFields < ActiveRecord::Migration
  def change
  	remove_column :listenings, :when
  	remove_column :messages, :session
  end
end
