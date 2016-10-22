class AddLikeAndAmbiance < ActiveRecord::Migration
  def change

  	# LIKE

  	create_table :albumslikes do |t|
      t.integer :album_id
      t.integer :user_id

      t.timestamps
    end

  	create_table :concertslikes do |t|
      t.integer :concert_id
      t.integer :user_id

      t.timestamps
    end

  	create_table :newslikes do |t|
      t.integer :news_id
      t.integer :user_id

      t.timestamps
    end

    # AMBIANCE

  	create_table :ambiances do |t|
      t.string :name

      t.timestamps
    end

  	create_table :ambiances_musics, id: false do |t|
      t.integer :ambiance_id, :null => false
      t.integer :music_id, :null => false
    end
  end
end
