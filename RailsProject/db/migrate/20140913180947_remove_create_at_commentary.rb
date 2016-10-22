class RemoveCreateAtCommentary < ActiveRecord::Migration
  def change
    remove_column :commentaries, :create_at
  end
end
