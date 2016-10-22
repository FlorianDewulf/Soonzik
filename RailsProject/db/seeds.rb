# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or create!d alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)


# Admin user
if (AdminUser.count == 0)
  AdminUser.create!(email: 'admin@soonzik.com', password: 'azertyuiop', password_confirmation: 'azertyuiop')
end

# Languages
languages = Language.create!(
	[
		{ language: "Français", abbreviation: "FR" },
		{ language: "English", abbreviation: "EN" }
	]
)

# Groups
artistGroup = Group.create!({ name: "Artist" })

########################
###   UTILISATEURS   ###
########################

# Addresses
	# for users
addr1 = Address.create!(numberStreet: 1, street: 'Rue des sciences', city: 'Strasbourg', country: 'France', zipcode: '67000')
addr2 = Address.create!(numberStreet: 2, street: 'Rue Solférino', city: 'Lille', country: 'France', zipcode: '59000')
addr3 = Address.create!(numberStreet: 3, street: 'Rue Nationale', city: 'Lyon', country: 'France', zipcode: '69000')
addr4 = Address.create!(numberStreet: 4, street: 'Rue de la paix', city: 'Paris', country: 'France', zipcode: '59000')
	# for concerts
addr5 = Address.create!(numberStreet: 5, street: 'Place Notre Dame', city: 'Tourcoing', country: 'France', zipcode: '59200')
addr6 = Address.create!(numberStreet: 28, street: 'Boulevard des Capucines', city: 'Paris', country: 'France', zipcode: '75009')
addr7 = Address.create!(numberStreet: 8, street: 'Boulevard de Bercy', city: 'Paris', country: 'France', zipcode: '75012')

# Users
u1 = User.create!(email: "user_one@gmail.com", password: "azertyuiop", fname: "Kevin", lname: "Lansel", username: "Sethyz", birthday: "1980-01-01 00:00:00", address_id: addr1.id, language: "FR", background: "04191c1a850e9b2a4907c00f5a576f431c68759d5ee38c3f91209721ed0a0ba9-vault-boy-fallout-cover.jpg", image: "390edf60727581a22c9c2eda21a92d74a19f36ad81336cad73a4f2226f3a443c-avatarCF.png")
u2 = User.create!(email: "user_two@gmail.com", password: "azertyuiop", fname: "Florian", lname: "Dewulf", username: "Lund", birthday: "1981-02-02 00:00:00", language: "EN", background: "88f0459a4158f6631c057f52fdf60c7dcac2125983e0ad8d39d3f6ab11b2f6fd-vault-boy-fallout-cover.jpg", image: "5564724a35f753977549815abdbf955315b19d63d0de7ab65db4dc6aca38a1b3-tarask.jpg")
u3 = User.create!(email: "user_three@gmail.com", password: "azertyuiop", fname: "Maxime", lname: "Wojciak", username: "Haz", birthday: "1982-03-03 00:00:00", language: "FR", image: "9100df8f5383a10d8accb26aae55ffe9b292be3c53f90741f8f9f0e15ad9b247-tarask.jpg")
u4 = User.create!(email: "user_four@gmail.com", password: "azertyuiop", fname: "Julien", lname: "Rodrigues", username: "Davold", birthday: "1983-04-04 00:00:00", address_id: addr2.id, language: "EN", image: "b29a4646a1eaa1708d4e4b18cbe0cab2a31780c1b0f5cf909200c811413b3507-BxulrrIAAAGpUq.jpg")
u5 = User.create!(email: "user_five@gmail.com", password: "azertyuiop", fname: "Gery", lname: "Baudry", username: "Hostilien", birthday: "1984-05-05 00:00:00", address_id: addr3.id, language: "FR", image: "cfd4b1776948cfd089aa67ece9216f6e04c91ad22939e343d005969fb9aaad46-avatarCF.png")
u6 = User.create!(email: "user_six@gmail.com", password: "azertyuiop", fname: "Maxime", lname: "Sauvage", username: "MaxSvg", birthday: "1985-06-06 00:00:00", address_id: addr4.id, language: "FR", image: "e2ab9423d9fac2f10bd1a9c8b68077470388cfe5e57804dc2e06e146d245f410-avatarCF.png")

# Artist
a1 = User.create!(email: "artist_one@gmail.com", password: "azertyuiop", fname: "Linkin", lname: "Park", username: "LinkinPark", birthday: "1990-01-01 00:00:00", language: "EN", image: "picture.jpg")
a2 = User.create!(email: "artist_two@gmail.com", password: "azertyuiop", fname: "Pretty", lname: "Lights", username: "PrettyLights", birthday: "1990-01-01 00:00:00", language: "EN")
a3 = User.create!(email: "artist_three@gmail.com", password: "azertyuiop", fname: "Three", lname: "Days Grace", username: "ThreeDaysGrace", birthday: "1990-01-01 00:00:00", language: "EN")
a4 = User.create!(email: "artist_four@gmail.com", password: "azertyuiop", fname: "Calvin", lname: "Harris", username: "CalvinHarris", birthday: "1990-01-01 00:00:00", language: "EN")
a5 = User.create!(email: "artist_five@gmail.com", password: "azertyuiop", fname: "Caravan", lname: "Palace", username: "CaravanPalace", birthday: "1990-01-01 00:00:00", language: "EN")
a6 = User.create!(email: "artist_six@gmail.com", password: "azertyuiop", fname: "OM", lname: "FG", username: "OMFG", birthday: "1990-01-01 00:00:00", language: "FR")
a7 = User.create!(email: "artist_seven@gmail.com", password: "azertyuiop", fname: "Nicky", lname: "Romero", username: "NickyRomero", birthday: "1990-01-01 00:00:00", language: "FR")
a8 = User.create!(email: "artist_eigh@gmail.com", password: "azertyuiop", fname: "Ephi", lname: "xa", username: "Ephixa", birthday: "1990-01-01 00:00:00", language: "FR")

# Asso
asso = User.create!(email: "association@gmail.com", password: "azertyuiop", fname: "Asso", lname: "Music", username: "MusicFun", birthday: "1990-01-01 00:00:00", language: "FR")

a1.groups << artistGroup
a2.groups << artistGroup
a3.groups << artistGroup
a4.groups << artistGroup
a5.groups << artistGroup
a6.groups << artistGroup
a7.groups << artistGroup
a8.groups << artistGroup

# Follow

Follow.create!([
	{ user_id: a1.id, follow_id: a2.id },
	{ user_id: a2.id, follow_id: a3.id },
	{ user_id: a3.id, follow_id: a4.id },
	{ user_id: a4.id, follow_id: a5.id },
	{ user_id: a5.id, follow_id: a6.id },
	{ user_id: a6.id, follow_id: a7.id },
	{ user_id: a7.id, follow_id: a8.id },
	{ user_id: u1.id, follow_id: u2.id },
	{ user_id: u2.id, follow_id: u3.id },
	{ user_id: u3.id, follow_id: u4.id },
	{ user_id: u4.id, follow_id: u5.id },
	{ user_id: u5.id, follow_id: u6.id },
])

Friend.create!([
	# u1 & u2
	{ user_id: u1.id, friend_id: u2.id },
	{ user_id: u2.id, friend_id: u1.id },
	# u1 & u6
	{ user_id: u6.id, friend_id: u1.id },
	{ user_id: u1.id, friend_id: u6.id },
	# u2 & u3
	{ user_id: u2.id, friend_id: u3.id },
	{ user_id: u3.id, friend_id: u2.id },
	# u2 & u5
	{ user_id: u5.id, friend_id: u2.id },
	{ user_id: u2.id, friend_id: u5.id },
	# u3 & u4
	{ user_id: u3.id, friend_id: u4.id },
	{ user_id: u4.id, friend_id: u3.id },
	# u3 & a1
	{ user_id: u3.id, friend_id: a1.id },
	{ user_id: a1.id, friend_id: u3.id },
	# u4 & u5
	{ user_id: u5.id, friend_id: u4.id },
	{ user_id: u4.id, friend_id: u5.id },
	# u5 & u6
	{ user_id: u5.id, friend_id: u6.id },
	{ user_id: u6.id, friend_id: u5.id },
	# a1 & a2
	{ user_id: a1.id, friend_id: a2.id },
	{ user_id: a2.id, friend_id: a1.id },
	# a3 & a4
	{ user_id: a3.id, friend_id: a4.id },
	{ user_id: a4.id, friend_id: a3.id },
	# a5 & u4
	{ user_id: a5.id, friend_id: u4.id },
	{ user_id: u4.id, friend_id: a5.id }
])

Identity.create!([
	{ user_id: u1.id, provider: "facebook", uid: 10205952532875286 },
	{ user_id: u1.id, provider: "twitter", uid: 2965987677 },
	{ user_id: u3.id, provider: "facebook", uid: 100000464246333 },
	{ user_id: u3.id, provider: "twitter", uid: 293075406 },
	{ user_id: u4.id, provider: "facebook", uid: 678388262 },
	{ user_id: u4.id, provider: "twitter", uid: 468791444 },
	{ user_id: u5.id, provider: "facebook", uid: 1554621818 },
	{ user_id: u5.id, provider: "twitter", uid: 1321128888 },
	{ user_id: u6.id, provider: "facebook", uid: 377507551 },
	{ user_id: u6.id, provider: "twitter", uid: 1519058626 }
])


###########################
###   CONTENU MUSICAL   ###
###########################

# Influence
influ = Influence.create!([
	{ name: "Electronic" },
	{ name: "Vocal" },
	{ name: "Rock" }
])

# Genres
genres = Genre.create!([
	{ style_name: "Rock'n roll", color_name: "red", color_hexa: "#FF0000" },
	{ style_name: "Rap", color_name: "green", color_hexa: "#00FF00" },
	{ style_name: "Techno", color_name: "blue", color_hexa: "#0000FF" },
	{ style_name: "Metal", color_name: "blue2", color_hexa: "#0000FE" },
	{ style_name: "Classique", color_name: "blue3", color_hexa: "#0000FD" },
	{ style_name: "Reggae", color_name: "blue4", color_hexa: "#0000FC" },
	{ style_name: "Pop", color_name: "blue5", color_hexa: "#0000FB" },
	{ style_name: "Chiptune", color_name: "blue6", color_hexa: "#0000FA" }
])

Influence.first.genres << genres[2]
Influence.first.genres << genres[7]
Influence.second.genres << genres[1]
Influence.second.genres << genres[4]
Influence.second.genres << genres[5]
Influence.second.genres << genres[6]
Influence.third.genres << genres[0]
Influence.third.genres << genres[3]

# Albums
albums = Album.create!([
	{ user_id: a1.id, title: "Meteora", image: "linkin.jpg", price: 17.0, file: "linkin.jpg", yearProd: 2006 },
	{ user_id: a2.id, title: "100% No Modern Talking", image: "knife.jpg", price: 12.0, file: "knife.jpg", yearProd: 2006 },
	{ user_id: a2.id, title: "Filling Up the City Skies", image: "pretty.jpg", price: 17.0, file: "pretty.jpg", yearProd: 2006 },
	{ user_id: a3.id, title: "Pain", image: "threedays.jpg", price: 13.0, file: "threedays.jpg", yearProd: 2006 },
	{ user_id: a4.id, title: "How deep is your love", image: "calvin.png", price: 14.0, file: "calvin.png", yearProd: 2006 },
	{ user_id: a5.id, title: "Caravan Palace", image: "caravan.jpg", price: 15.0, file: "caravan.jpg", yearProd: 2006 },
	{ user_id: a5.id, title: "LnP Root Family", image: "lnp.jpg", price: 16.0, file: "lnp.jpg", yearProd: 2006 },
	{ user_id: a6.id, title: "Yeah", image: "yeah.jpg", price: 16.0, file: "yeah.jpg", yearProd: 2006 },
	{ user_id: a7.id, title: "Appeal to reason", image: "rise.jpg", price: 11.0, file: "rise.jpg", yearProd: 2003 },
	{ user_id: a8.id, title: "Awesome to the max", image: "ephixa.jpg", price: 10.0, file: "ephixa.jpg", yearProd: 2000 }
])

albums[0].genres << genres[2]
albums[1].genres << genres[3]
albums[2].genres << genres[2]
albums[3].genres << genres[0]
albums[4].genres << genres[2]
albums[5].genres << genres[6]
albums[6].genres << genres[5]
albums[7].genres << genres[7]
albums[8].genres << genres[0]

pack = Pack.create!([
	{title: "First pack #1", association_id: asso.id, begin_date: Time.now, end_date: Time.now + 10000000 + 20000, minimal_price: 1.0},
	{title: "Second pack #2", association_id: asso.id, begin_date: Time.now, end_date: Time.now + 20000000 + 20000, minimal_price: 4.0},
	{title: "Special Rock !", association_id: asso.id, begin_date: Time.now, end_date: Time.now + 283700000 + 20000, minimal_price: 3.0}
])
pack[0].albums << albums[0]
pack[0].albums << albums[1]
pack[0].albums << albums[2]
pack[0].albums << albums[3]
pack[0].albums << albums[4]

pack[1].albums << albums[4]
pack[1].albums << albums[5]
pack[1].albums << albums[6]
pack[1].albums << albums[7]
pack[1].albums << albums[8]

pack[2].albums << albums[3]
pack[2].albums << albums[1]
pack[2].albums << albums[8]

PartialAlbum.create!([
	{ pack_id: pack[0].id, album_id: albums[3].id },
	{ pack_id: pack[0].id, album_id: albums[4].id },
	{ pack_id: pack[1].id, album_id: albums[6].id },
	{ pack_id: pack[1].id, album_id: albums[7].id },
	{ pack_id: pack[1].id, album_id: albums[8].id },
	{ pack_id: pack[2].id, album_id: albums[8].id },
])

a1.reload
a2.reload
a3.reload
a4.reload
a5.reload
a6.reload
a7.reload
a8.reload

# Musics
musics = Music.create!([
	# artist 1
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "True Survivor", duration: 213, price: 1, file: "TrueSurvivor", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "You and Me", duration: 193, price: 1, file: "YouMeFlumeRemix", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Remember the name", duration: 193, price: 1, file: "RememberTheName", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Breaking The Habit", duration: 193, price: 1, file: "BreakingTheHabit", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Lying from You", duration: 193, price: 1, file: "LyingFromYou", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Wastelands", duration: 193, price: 1, file: "Wastelands", limited: true },
	{ user_id: a1.id, album_id: a1.albums.first.id, title: "Rebellion", duration: 193, price: 1, file: "Rebellion", limited: true },
	# artist 2
	{ user_id: a2.id, album_id: a2.albums.second.id, title: "Bullseye", duration: 193, price: 1, file: "Bullseye", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Finally Moving", duration: 193, price: 1, file: "FinallyMoving", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Hot Like Sauce", duration: 193, price: 1, file: "HotLikeSauce", limited: true },
	{ user_id: a2.id, album_id: a2.albums.second.id, title: "Internet Friends", duration: 193, price: 1, file: "InternetFriends", limited: true },
	{ user_id: a2.id, album_id: a2.albums.second.id, title: "Nightcall", duration: 193, price: 1, file: "Nightcall", limited: true },
	{ user_id: a2.id, album_id: a2.albums.first.id, title: "Who Loves Me", duration: 193, price: 1, file: "WhoLovesMe", limited: true },
	# artist 3
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Animal I Have Become", duration: 193, price: 1, file: "AnimalIHaveBecome", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "I hate everything about you", duration: 193, price: 1, file: "IHateEverythingAboutYou", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Iron", duration: 193, price: 1, file: "Iron", limited: true },
	{ user_id: a3.id, album_id: a3.albums.first.id, title: "Riot", duration: 193, price: 1, file: "Riot", limited: true },
	# artist 4
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Balls to the wall", duration: 193, price: 1, file: "BallstotheWall", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "Do I wanna know ?", duration: 193, price: 1, file: "DoIWannaKnow_", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "How deep is your love", duration: 193, price: 1, file: "HowDeepIsYourLove", limited: true },
	{ user_id: a4.id, album_id: a4.albums.first.id, title: "In One Ear", duration: 193, price: 1, file: "InOneEar", limited: true },
	# artist 5
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Lazy Place", duration: 193, price: 1, file: "LazyPlace", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "Suzy", duration: 193, price: 1, file: "Suzy", limited: true },
	{ user_id: a5.id, album_id: a5.albums.first.id, title: "StarScat", duration: 193, price: 1, file: "StarScat", limited: true },
	{ user_id: a5.id, album_id: a5.albums.second.id, title: "Good vibes", duration: 193, price: 1, file: "Goodvibes", limited: true },
	{ user_id: a5.id, album_id: a5.albums.second.id, title: "La voix du peuple", duration: 193, price: 1, file: "Lavoixdupeuple", limited: true },
	{ user_id: a5.id, album_id: a5.albums.second.id, title: "Les voisins", duration: 193, price: 1, file: "Lesvoisins", limited: true },
	# artist 6
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Hello", duration: 193, price: 1, file: "Hello", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Ice Cream", duration: 193, price: 1, file: "IceCream", limited: true },
	{ user_id: a6.id, album_id: a6.albums.first.id, title: "Once Again", duration: 193, price: 1, file: "OnceAgain", limited: true },
	# artist 7
	{ user_id: a7.id, album_id: a7.albums.first.id, title: "Burn It To The Ground", duration: 193, price: 1, file: "BurnItToTheGround", limited: true },
	{ user_id: a7.id, album_id: a7.albums.first.id, title: "Lean On", duration: 193, price: 1, file: "LeanOn", limited: true },
	{ user_id: a7.id, album_id: a7.albums.first.id, title: "Prayer Of The Refugee", duration: 193, price: 1, file: "PrayerOfTheRefugee", limited: true },
	{ user_id: a7.id, album_id: a7.albums.first.id, title: "Savior", duration: 193, price: 1, file: "Savior", limited: true },
	{ user_id: a7.id, album_id: a7.albums.first.id, title: "Toulouse (Original Mix)", duration: 193, price: 1, file: "ToulouseOriginalMix", limited: true },
	# artist 8
	{ user_id: a8.id, album_id: a8.albums.first.id, title: "Awesome to the max", duration: 193, price: 1, file: "AwesometotheMax", limited: true },
	{ user_id: a8.id, album_id: a8.albums.first.id, title: "Habits", duration: 193, price: 1, file: "Habits", limited: true },
	{ user_id: a8.id, album_id: a8.albums.first.id, title: "Ideekay", duration: 193, price: 1, file: "Ideekay", limited: true },
	{ user_id: a8.id, album_id: a8.albums.first.id, title: "The Devil in I", duration: 193, price: 1, file: "TheDevilInI", limited: true },
	{ user_id: a8.id, album_id: a8.albums.first.id, title: "Warrior Concerto", duration: 193, price: 1, file: "WarriorConcerto", limited: true }
])

musics.each do |music|
	if (music.album.genres[0])
		music.genres << music.album.genres[0]
	end
end

####################
###   Services   ###
####################

news = News.create!([
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id },
	{ author_id: u1.id }
])

Newstext.create!([
	# news 1
	{ content: "Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français", language: "FR", news_id: news[0].id },
	{ content: "Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english", language: "EN", news_id: news[0].id },
	# news 2
	{ content: "[Français] Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac tempus tellus. Aliquam elementum ultrices orci, in viverra magna rutrum a. Donec ac nibh enim. Aliquam viverra nunc nisi. Donec ac arcu congue metus egestas posuere. Suspendisse nec varius nulla. Sed sollicitudin viverra risus at sollicitudin.

In facilisis finibus mauris, quis convallis ante cursus vitae. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam iaculis sagittis suscipit. Nam nec felis pulvinar, tincidunt risus fermentum, malesuada massa. Nulla facilisi. Curabitur vel enim id sem varius mollis. Ut dapibus, eros ut placerat tristique, lacus mi porttitor dui, id maximus enim ante eget lectus. Integer sagittis dui quam, quis volutpat lorem tristique vel. Vivamus in faucibus augue, nec consequat purus. Duis dignissim suscipit nibh sit amet molestie. Suspendisse luctus arcu ac aliquet tincidunt. Nunc eget leo eget erat tincidunt vestibulum sit amet sit amet quam. Ut a laoreet lacus. Maecenas ultricies viverra metus eu tempor. Integer nec nisi iaculis, malesuada nulla in, finibus quam. In rhoncus id dui auctor blandit.

Etiam eros justo, imperdiet et mattis quis, iaculis sed tellus. Phasellus lacinia sem eget pretium imperdiet. Morbi volutpat eros justo. Donec mauris augue, mollis sit amet venenatis vitae, sollicitudin non augue. Cras nisi tortor, cursus eu imperdiet sed, semper vel nisl. In et rutrum magna. Sed maximus ex ut venenatis pharetra. Duis hendrerit, mauris a euismod pellentesque, augue nisi volutpat odio, non ullamcorper sem turpis at magna.

Morbi facilisis eros vel arcu cursus, id mattis felis accumsan. Suspendisse sollicitudin dapibus vehicula. Proin ac porttitor neque, ut pellentesque felis. Donec maximus nibh eget sagittis pulvinar. Suspendisse consectetur aliquam leo, sit amet sodales justo porta et. Nam congue ligula eget nulla varius vestibulum non sit amet nisi. Nullam congue libero vitae condimentum dictum. Duis bibendum hendrerit ullamcorper. Curabitur a ullamcorper justo. Fusce eget porttitor odio. Ut vestibulum interdum lectus eu venenatis. Nulla at mollis ex, maximus dapibus dolor.

Quisque dapibus, nunc sed lobortis dictum, elit quam semper est, a finibus justo lectus eu nisl. Cras arcu nisi, faucibus eget lectus quis, iaculis pretium erat. Ut convallis magna at ornare mollis. Sed finibus, metus sed tincidunt scelerisque, leo erat blandit nibh, ac cursus ipsum ex nec mauris. Ut pellentesque orci ut tortor tincidunt efficitur. Vestibulum sapien velit, dictum ornare magna ac, sollicitudin egestas libero. In id ex elementum, molestie nisl et, vestibulum velit. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aenean non sem viverra, ultrices elit et, porttitor arcu. Ut vel vehicula velit, sit amet tempor tortor.", language: "FR", news_id: news[1].id },
	{ content: "[English] Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac tempus tellus. Aliquam elementum ultrices orci, in viverra magna rutrum a. Donec ac nibh enim. Aliquam viverra nunc nisi. Donec ac arcu congue metus egestas posuere. Suspendisse nec varius nulla. Sed sollicitudin viverra risus at sollicitudin.

In facilisis finibus mauris, quis convallis ante cursus vitae. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam iaculis sagittis suscipit. Nam nec felis pulvinar, tincidunt risus fermentum, malesuada massa. Nulla facilisi. Curabitur vel enim id sem varius mollis. Ut dapibus, eros ut placerat tristique, lacus mi porttitor dui, id maximus enim ante eget lectus. Integer sagittis dui quam, quis volutpat lorem tristique vel. Vivamus in faucibus augue, nec consequat purus. Duis dignissim suscipit nibh sit amet molestie. Suspendisse luctus arcu ac aliquet tincidunt. Nunc eget leo eget erat tincidunt vestibulum sit amet sit amet quam. Ut a laoreet lacus. Maecenas ultricies viverra metus eu tempor. Integer nec nisi iaculis, malesuada nulla in, finibus quam. In rhoncus id dui auctor blandit.

Etiam eros justo, imperdiet et mattis quis, iaculis sed tellus. Phasellus lacinia sem eget pretium imperdiet. Morbi volutpat eros justo. Donec mauris augue, mollis sit amet venenatis vitae, sollicitudin non augue. Cras nisi tortor, cursus eu imperdiet sed, semper vel nisl. In et rutrum magna. Sed maximus ex ut venenatis pharetra. Duis hendrerit, mauris a euismod pellentesque, augue nisi volutpat odio, non ullamcorper sem turpis at magna.

Morbi facilisis eros vel arcu cursus, id mattis felis accumsan. Suspendisse sollicitudin dapibus vehicula. Proin ac porttitor neque, ut pellentesque felis. Donec maximus nibh eget sagittis pulvinar. Suspendisse consectetur aliquam leo, sit amet sodales justo porta et. Nam congue ligula eget nulla varius vestibulum non sit amet nisi. Nullam congue libero vitae condimentum dictum. Duis bibendum hendrerit ullamcorper. Curabitur a ullamcorper justo. Fusce eget porttitor odio. Ut vestibulum interdum lectus eu venenatis. Nulla at mollis ex, maximus dapibus dolor.

Quisque dapibus, nunc sed lobortis dictum, elit quam semper est, a finibus justo lectus eu nisl. Cras arcu nisi, faucibus eget lectus quis, iaculis pretium erat. Ut convallis magna at ornare mollis. Sed finibus, metus sed tincidunt scelerisque, leo erat blandit nibh, ac cursus ipsum ex nec mauris. Ut pellentesque orci ut tortor tincidunt efficitur. Vestibulum sapien velit, dictum ornare magna ac, sollicitudin egestas libero. In id ex elementum, molestie nisl et, vestibulum velit. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aenean non sem viverra, ultrices elit et, porttitor arcu. Ut vel vehicula velit, sit amet tempor tortor.", language: "EN", news_id: news[1].id },
	# news 3
	{ content: "L'ouverture du site nous a permis de promouvoir de nombreux artistes indépendants, félicitation à tous et merci.", language: "FR", news_id: news[2].id },
	{ content: "The opening of the website allowed us to promote a lot of indie artists, congratulation to everybody and thanks.", language: "EN", news_id: news[2].id },
	# news 4
	{ content: "Affluence record sur le site hier soir, nous vous remercions !", language: "FR", news_id: news[3].id },
	{ content: "Best attendance last night on the site, we would thank you !", language: "EN", news_id: news[3].id },
	# news 5
	{ content: "Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français", language: "FR", news_id: news[4].id },
	{ content: "Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english", language: "EN", news_id: news[4].id },
	# news 6
	{ content: "Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français. Voici le contenu de ma news en français", language: "FR", news_id: news[5].id },
	{ content: "Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english. Here is the content of my news in english", language: "EN", news_id: news[5].id },
])

news.each_with_index do |n, index|
	NewsTitle.create!([
		{ news_id: n.id, title: "Titre de ma news num #{index}", language: "FR" },
		{ news_id: n.id, title: "Title of my news num #{index}", language: "EN" }
	])

	n.attachments << Attachment.create!({ url: "news#{index + 1}.jpeg", file_size: 1024, content_type: "image/jpeg" })
end

battle1 = Battle.create!({ date_begin: "2015-10-01 00:00:00", date_end: "2015-12-10 00:00:00", artist_one_id: a1.id, artist_two_id: a2.id })
battle2 = Battle.create!({ date_begin: "2015-11-01 00:00:00", date_end: "2016-01-10 00:00:00", artist_one_id: a3.id, artist_two_id: a4.id })
battle3 = Battle.create!({ date_begin: "2015-12-01 00:00:00", date_end: "2016-02-10 00:00:00", artist_one_id: a5.id, artist_two_id: a6.id })

Concert.create!([
	{ user_id: a5.id, planification: "2016-01-01 00:00:00", address_id: addr5.id, url: nil },
	{ user_id: a6.id, planification: "2016-02-01 00:00:00", address_id: addr6.id, url: "http://www.google.fr" },
	{ user_id: a7.id, planification: "2016-03-01 00:00:00", address_id: addr7.id, url: nil }
])

##################
###   Social   ###
##################

Tweet.create!([
	{ msg: "Wow, nice tweet module :)", user_id: u1.id },
	{ msg: "Wow, nice tweet module :)", user_id: u2.id },
	{ msg: "Wow, nice tweet module :)", user_id: u3.id },
	{ msg: "Wow, nice tweet module :)", user_id: u4.id },
	{ msg: "Wow, nice tweet module :)", user_id: u5.id },
	{ msg: "Wow, nice tweet module :)", user_id: u6.id },
	{ msg: "Ceci est un test de Sweet", user_id: a1.id },
	{ msg: "Ceci est un test de Sweet", user_id: a2.id },
	{ msg: "Ceci est un test de Sweet", user_id: a3.id },
	{ msg: "Ceci est un test de Sweet", user_id: a4.id },
	{ msg: "Ceci est un test de Sweet", user_id: a5.id },
	{ msg: "Ceci est un test de Sweet", user_id: a6.id },
	{ msg: "Nice work @OMFG I love your musics", user_id: u1.id },
	{ msg: "I love you @Ephixa !", user_id: u2.id },
	{ msg: "Le travail de @LinkinPark a toujours été génial !", user_id: u3.id },
	{ msg: "Pure musique de @CalvinHarris :)", user_id: u4.id },
	{ msg: "Joli travail @Lund pour le site", user_id: u5.id },
	{ msg: "Hello @Haz <3", user_id: u6.id },
	{ msg: "There is a battle between @#{a1.username} and @#{a2.username} omg =O", user_id: u1.id },
	{ msg: "There is a battle between @#{a3.username} and @#{a4.username} omg =O", user_id: u2.id },
	{ msg: "There is a battle between @#{a5.username} and @#{a6.username} omg =O", user_id: u3.id },
])

Vote.create!([
	{ user_id: a1.id, battle_id: battle1.id, artist_id: a1.id },
	{ user_id: a2.id, battle_id: battle1.id, artist_id: a1.id },
	{ user_id: u1.id, battle_id: battle2.id, artist_id: a3.id },
	{ user_id: u2.id, battle_id: battle2.id, artist_id: a4.id },
	{ user_id: u5.id, battle_id: battle3.id, artist_id: a6.id },
	{ user_id: u6.id, battle_id: battle3.id, artist_id: a6.id },
])

# Listening

#48.8101 2.3569		Kremlin Bicetre
#48.8695 2.3315		Rue de la paix
Listening.create!([
	{ user_id: u1.id, music_id: Music.first.id, latitude: 48.81, longitude: 2.31 },
	{ user_id: u1.id, music_id: Music.second.id, latitude: 48.82, longitude: 2.33 },
	{ user_id: u1.id, music_id: Music.third.id, latitude: 48.83, longitude: 2.32 },
	{ user_id: u1.id, music_id: Music.fourth.id, latitude: 48.84, longitude: 2.34 },
	{ user_id: u2.id, music_id: Music.fifth.id, latitude: 48.85, longitude: 2.36 },
	{ user_id: u2.id, music_id: Music.offset(5).first.id, latitude: 48.86, longitude: 2.35 },
	{ user_id: u2.id, music_id: Music.offset(6).first.id, latitude: 48.87, longitude: 2.38 },
	{ user_id: u2.id, music_id: Music.offset(7).first.id, latitude: 48.88, longitude: 2.37 },

	{ user_id: u3.id, music_id: Music.first.id, latitude: 48.815, longitude: 2.28 },
	{ user_id: u3.id, music_id: Music.second.id, latitude: 48.845, longitude: 2.32 },
	{ user_id: u3.id, music_id: Music.third.id, latitude: 48.835, longitude: 2.29 },
	{ user_id: u3.id, music_id: Music.fourth.id, latitude: 48.825, longitude: 2.26 },
	{ user_id: u4.id, music_id: Music.fifth.id, latitude: 48.815, longitude: 2.36 },
	{ user_id: u4.id, music_id: Music.offset(5).first.id, latitude: 48.90, longitude: 2.40 },
	{ user_id: u4.id, music_id: Music.offset(6).first.id, latitude: 48.91, longitude: 2.39 },
	{ user_id: u4.id, music_id: Music.offset(7).first.id, latitude: 48.78, longitude: 2.42 },

	{ user_id: u5.id, music_id: Music.first.id, latitude: 48.4, longitude: 2.32 },
	{ user_id: u5.id, music_id: Music.second.id, latitude: 48.5, longitude: 2.39 },
	{ user_id: u5.id, music_id: Music.third.id, latitude: 48.45, longitude: 2.31 },
	{ user_id: u5.id, music_id: Music.fourth.id, latitude: 48.48, longitude: 2.25 },
	{ user_id: u6.id, music_id: Music.fifth.id, latitude: 48.54, longitude: 2.37 },
	{ user_id: u6.id, music_id: Music.offset(5).first.id, latitude: 48.56, longitude: 2.34 },
	{ user_id: u6.id, music_id: Music.offset(6).first.id, latitude: 48.49, longitude: 2.23 },
	{ user_id: u6.id, music_id: Music.offset(7).first.id, latitude: 48.52, longitude: 2.42 },
])