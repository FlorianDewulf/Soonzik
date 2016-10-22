class SocialToken < ActiveRecord::Migration
  def change
  	add_column :identities, :token, :string, :null => false, :default => ""
  end
end
