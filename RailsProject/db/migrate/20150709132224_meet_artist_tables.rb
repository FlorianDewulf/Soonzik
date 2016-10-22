class MeetArtistTables < ActiveRecord::Migration
  def change
    create_table :meets do |t|
    	t.string :query, :null => false
      t.string :profession, :null => false
      t.string :what, :null => false
      t.datetime :fromDate, :null => false
      t.datetime :toDate, :null => false
      t.string :location, :null => false
      t.string :email, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end

    create_table :meetstrings do |t|
    	t.string :language, :null => false
      t.string :str, :null => false
      t.string :stringType, :null => false

      t.timestamps
    end

    # FR
    Meetstring.create!({ language: 'FR', str: 'Chanteur', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'Guitariste', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'Batteur', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'Bassiste', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'Violoniste', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'DJ', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'Compositeur', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'Saxophoniste', stringType: 'profession' })
    Meetstring.create!({ language: 'FR', str: 'Autre', stringType: 'profession' })

    Meetstring.create!({ language: 'FR', str: 'Créer un groupe', stringType: 'type' })
    Meetstring.create!({ language: 'FR', str: 'Une musique', stringType: 'type' })
    Meetstring.create!({ language: 'FR', str: 'Un album', stringType: 'type' })
    Meetstring.create!({ language: 'FR', str: 'Des conseils', stringType: 'type' })

    # EN
    Meetstring.create!({ language: 'EN', str: 'Singer', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'Guitarist', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'Drummer', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'Bassist', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'Violonist', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'DJ', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'Composer', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'Saxophonist', stringType: 'profession' })
    Meetstring.create!({ language: 'EN', str: 'Other', stringType: 'profession' })

    Meetstring.create!({ language: 'EN', str: 'Create a band', stringType: 'type' })
    Meetstring.create!({ language: 'EN', str: 'A music', stringType: 'type' })
    Meetstring.create!({ language: 'EN', str: 'An album', stringType: 'type' })
    Meetstring.create!({ language: 'EN', str: 'Some advices', stringType: 'type' })
  end
end
