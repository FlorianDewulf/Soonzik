class RepatchUselessColumnUser < ActiveRecord::Migration
  def change
    # delete useless columns
    remove_column :users, :signin
    remove_column :users, :activated
  end
end
