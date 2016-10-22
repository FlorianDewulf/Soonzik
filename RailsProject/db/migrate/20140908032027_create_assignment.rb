class CreateAssignment < ActiveRecord::Migration
  def change
    create_table :follows, id: false do |t|
      t.integer :user_id, :null => false
      t.integer :follow_id, :null => false
    end

    create_table :commentaries_albums, id: false do |t|
      t.integer :commentary_id, :null => false
      t.integer :album_id, :null => false
    end

    create_table :commentaries_musics, id: false do |t|
      t.integer :commentary_id, :null => false
      t.integer :music_id, :null => false
    end

    create_table :commentaries_news, id: false do |t|
      t.integer :commentary_id, :null => false
      t.integer :news_id, :null => false
    end

    create_table :descriptions_albums, id: false do |t|
      t.integer :description_id, :null => false
      t.integer :album_id, :null => false
    end

    create_table :descriptions_musics, id: false do |t|
      t.integer :description_id, :null => false
      t.integer :music_id, :null => false
    end

    create_table :descriptions_influences, id: false do |t|
      t.integer :description_id, :null => false
      t.integer :influence_id, :null => false
    end

    create_table :descriptions_genres, id: false do |t|
      t.integer :description_id, :null => false
      t.integer :genre_id, :null => false
    end

    create_table :friends, id: false do |t|
      t.integer :user_id, :null => false
      t.integer :friend_id, :null => false
    end

    create_table :influences_genres, id: false do |t|
      t.integer :influence_id, :null => false
      t.integer :genre_id, :null => false
    end

    create_table :news_attachments, id: false do |t|
      t.integer :news_id, :null => false
      t.integer :attachment_id, :null => false
    end

    create_table :packs_albums, id: false do |t|
      t.integer :album_id, :null => false
      t.integer :pack_id, :null => false
    end

    create_table :playlists_musics, id: false do |t|
      t.integer :music_id, :null => false
      t.integer :playlist_id, :null => false
    end

    create_table :users_groups, id: false do |t|
      t.integer :user_id, :null => false
      t.integer :group_id, :null => false
    end
  end
end
