class NewstextLikeNewstitle < ActiveRecord::Migration
  def change
  	remove_column :newstexts, :title
  end
end
