class RenameLinkTables < ActiveRecord::Migration
  def change
    rename_table :commentaries_albums, :albums_commentaries
    rename_table :descriptions_albums, :albums_descriptions
    rename_table :influences_genres, :genres_influences
    rename_table :news_attachments, :attachments_news
    rename_table :packs_albums, :albums_packs
    rename_table :playlists_musics, :musics_playlists
    rename_table :users_groups, :groups_users
  end
end
