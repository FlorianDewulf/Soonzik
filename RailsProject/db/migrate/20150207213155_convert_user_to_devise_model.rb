class ConvertUserToDeviseModel < ActiveRecord::Migration
  def change
  	create_table :identities do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    #Convert DeviseModel
	rename_column :users, :password, :encrypted_password
	change_column_default :users, :email, ""
	change_column_default :users, :encrypted_password, ""

    # Recoverable
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    # Rememberable
    add_column :users, :remember_created_at, :datetime

    # Trackable
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string

    # Confirmable
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # Only for reconfirmation
    User.update_all(:confirmed_at => Time.now)

    # Secret Question
    add_column :users, :question, :string
    add_column :users, :answer, :string

    add_index :users, :username,             unique: true
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true

    # delete useless columns
    remove_column :users, :signin
    remove_column :users, :activated
  end
end
