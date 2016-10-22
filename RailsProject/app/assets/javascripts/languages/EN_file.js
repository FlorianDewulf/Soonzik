/*
	Nomenclature :

	(display|file)_(position|controller)_(what is the text about)_(what kind of text)_(singular/plural)

	/-------------/

	Explication :

	display = front
	file = text generated from javascript file
	--------------
	position = where does come from the text
	controller = if it comes from file, the name of the controller
	---------------
	singular and plural are optionnal
*/

// From the header

var labels = {
	// Header View
	DISPLAY_MENU_NOTIFICATION_LABEL_SINGULAR: "Notification",
	DISPLAY_MENU_NOTIFICATION_LABEL_PLURAL: "Notifications",
	DISPLAY_MENU_PROFILE_EDITION_LABEL: "Edit profile",
	DISPLAY_MENU_NEWS_LABEL: "News",
	DISPLAY_MENU_EXPLORER_LABEL: "Explorer",
	DISPLAY_MENU_PACKS_LABEL: "Packs",
	DISPLAY_MENU_BATTLES_LABEL: "Battles",
	DISPLAY_MENU_FRIENDS_LABEL: "Friends",
	DISPLAY_MENU_LISTENING_LABEL: "Listening",
	DISPLAY_MENU_CONCERT_LABEL: "Tours",
	DISPLAY_MENU_CART_LABEL: "My cart",
	DISPLAY_MENU_MUSIC_LABEL: "My music",
	DISPLAY_MENU_FEEDBACK_LABEL: "Feedback",
	DISPLAY_MENU_SIGNUP_LABEL: "Sign up",
	DISPLAY_MENU_LOGIN_LABEL: "Login",
	DISPLAY_MENU_LOGOUT_LABEL: "Log out",
	DISPLAY_MENU_SEARCH_PLACEHOLDER: "Search users, musics, albums...",

	// Header Controller
	FILE_MENU_LANGUAGE_ERROR_LABEL: "Error while changing the language",

	// Album Controller
	FILE_ALBUM_ADD_ALBUM_MESSAGE: "Album successfuly adding into the cart",
	FILE_ALBUM_ADD_ALBUM_ERROR_MESSAGE: "An error occured while adding album into the cart",
	FILE_ALBUM_ADD_SONG_MESSAGE: "Song is successfuly add into the cart",
	FILE_ALBUM_ADD_SONG_ERROR_MESSAGE: "An error occured while adding song into the cart",
	FILE_ALBUM_GET_NOTES_ERROR_MESSAGE: "Error while loading your notes",
	FILE_ALBUM_GET_ALBUM_ERROR_MESSAGE: "Error while loading the album",
	FILE_ALBUM_SET_NOTE_ERROR_MESSAGE: "Error while rating the music, please try later.",
	FILE_ALBUM_LOAD_COMMENT_ERROR_MESSAGE: "Error while loading commentaries",
	FILE_ALBUM_SEND_COMMENT_ERROR_MESSAGE: "Error while saving your comment, please try later",

	// Battle Controller
	FILE_BATTLE_LOAD_BATTLE_ERROR_MESSAGE: "Error while loading the page",
	FILE_BATTLE_LOAD_ARTIST_ONE_ERROR_MESSAGE: "Error while loading the profile of the first artist.",
	FILE_BATTLE_LOAD_ARTIST_TWO_ERROR_MESSAGE: "Error while loading the profile of the second artist.",
	FILE_BATTLE_NEED_AUTHENTICATION_ERROR_MESSAGE: "You need to be authenticated",
	FILE_BATTLE_VOTE_ERROR_MESSAGE: "An error occured while voting. Try again later.",
	FILE_BATTLE_ALREADY_VOTED_ERROR_MESSAGE: "This action is impossible : You already vote for this artist",
	FILE_BATTLE_VOTETEXT_LABEL: "Vote",
	FILE_BATTLE_VOTEDTEXT_LABEL: "You voted for this artist",
	FILE_BATTLE_CANCEL_TEXT_LABEL: "Cancel your old vote and vote for this artist !",

	// Chat Controller
	FILE_CHAT_GET_MESSAGE_ERROR_MESSAGE: "An error occured during the loading",

	// Explorer Controller
	FILE_EXPLORER_GET_INFLUENCES_ERROR_MESSAGE: "Error while loading the influences",
	FILE_EXPLORER_GET_AMBIANCES_ERROR_MESSAGE: "Error while loading the ambiances",
	FILE_EXPLORER_GET_AMBIANCE_ERROR_MESSAGE: "Error while loading the ambiance",
	FILE_EXPLORER_GET_GENRE_ERROR_MESSAGE: "Error while loading the genre",

	// Listening Controller
	FILE_LISTENING_AROUND_ERROR_MESSAGE: "Error while loading the music around you",
	FILE_LISTENING_INPOPUP_LISTENED_LABEL: " listened by ",

	// Notification Controller
	FILE_NOTIFICATION_TWEET_NOTIF_MESSAGE: " has tweeted something to you",
	FILE_NOTIFICATION_FRIEND_NOTIF_MESSAGE: " has added you as friend",
	FILE_NOTIFICATION_FOLLOW_NOTIF_MESSAGE: " follow you",
	FILE_NOTIFICATION_ASREAD_NOTIF_ERROR_MESSAGE: "Can't mark your notification as read",
	FILE_NOTIFICATION_MORE_NOTIF_ERROR_MESSAGE: "An error occured, can't get more notifications. Try Later.",

	// Player Controller
	FILE_PLAYER_FIND_PLAYLIST_ERROR_MESSAGE: "Error : Can't get your playlist",
	FILE_PLAYER_REMOVE_FROM_PLAYLIST_ERROR_MESSAGE: "Error while deleting the music from the playlist",
	FILE_PLAYER_SAVE_IN_PLAYLIST_ERROR_MESSAGE: "Error while saving a new music in the playlist",
	FILE_PLAYER_PLAY_MUSIC_ERROR_MESSAGE: "Error while loading the music : ",
	FILE_PLAYER_GEOLOC_MUSIC_ERROR_MESSAGE: "Can't add a music for geolocation",
	FILE_PLAYER_DELETE_PLAYLIST_ERROR_MESSAGE: "An error occured while deleting the playlist ",

	// Playlist Controller
	FILE_PLAYLIST_BAD_ARGUMENT_ERROR_MESSAGE: "Can't load this playlist",
	FILE_PLAYLIST_FIND_PLAYLIST_ERROR_MESSAGE: "Error while deleting the playlist : ",
	FILE_PLAYLIST_GET_PLAYLIST_ERROR_MESSAGE: "Error while loading information of the playlist",
	FILE_PLAYLIST_GET_MUSIC_ERROR_MESSAGE: "Error while loading information of the music number ",
	FILE_PLAYLIST_TMP_NAME_LABEL: "Temporary Playlist",
	FILE_PLAYLIST_NEW_MUSIC_ERROR_MESSAGE: "Error while saving a new music in the playlist",

	// Search Controller
	FILE_SEARCH_REQUEST_ERROR_MESSAGE: "An error occured while loading the results of your search",

	// User Controller
	FILE_USER_MONTHS_INFORMATION: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
	FILE_USER_FIND_PLAYLIST_ERROR_MESSAGE: "Error while deleting the playlist : ",
	FILE_USER_GET_NOTES_ERROR_MESSAGE: "Error while loading your notes",
	FILE_USER_GET_FOLLOWERS_ERROR_MESSAGE: "An error occured while loading the followers of this profile",
	FILE_USER_GET_FOLLOWS_ERROR_MESSAGE: "An error occured while loading the follows of this profile",
	FILE_USER_GET_FRIENDS_ERROR_MESSAGE: "An error occured while loading the friends of this profile",
	FILE_USER_GET_PLAYLISTS_ERROR_MESSAGE: "An error occured while loading the playlists of this profile",
	FILE_USER_PROFILE_ERROR_MESSAGE: "An error occured while loading this profile",
	FILE_USER_EDITION_ERROR_MESSAGE: "You can't edit this profile : it is not yours",
	FILE_USER_UPDATE_SUCCESS_MESSAGE: "Profile updated successfully",
	FILE_USER_ERROR_OCCURED_MESSAGE: "An error occured",
	FILE_USER_FOLLOW_ERROR_MESSAGE: "An error occured while following an user",
	FILE_USER_FRIEND_ERROR_MESSAGE: "An error occured while adding a friend",
	FILE_USER_UNFOLLOW_ERROR_MESSAGE: "An error occured while unfollowing an user",
	FILE_USER_UNFFRIEND_ERROR_MESSAGE: "An error occured while removing a friend",
	FILE_USER_SAVE_TWEET_ERROR_MESSAGE: "Error while saving the tweet",
	FILE_USER_TWEET_TOO_LONG_ERROR_MESSAGE: "Your message is too big. Length max. is 140 characters.",
	FILE_USER_SET_NOTE_ERROR_MESSAGE: "Error while rating the music, please try later.",
	FILE_USER_NEED_LOGIN_ERROR_MESSAGE: "You need to login for this action",
	FILE_USER_ADD_PLAYLIST_ERROR_MESSAGE: "Error while saving a new music in the playlist",
	FILE_USER_FB_LINKED_ERROR_MESSAGE: "The Facebook account is already linked to another SoonZik account",
	FILE_USER_FB_LINK_ERROR_MESSAGE: "Can't link the social network to your profile, try again later.",
	FILE_USER_GOOGLE_LINKED_ERROR_MESSAGE: "The Google Plus account is already linked to another SoonZik account",
	FILE_USER_GOOGLE_LINK_ERROR_MESSAGE: "Can't link the social network to your profile, try again later.",
	FILE_USER_GOOGLE_CONNECTION_ERROR_MESSAGE: "Can't connect to Google, please try later",
	FILE_USER_SOUNDCLOUD_CONNECTION_ERROR_MESSAGE: "Can't connect to Soundcloud, please try later",
	FILE_USER_MUSICAL_PAST_SUCCESS_MESSAGE: "We have your musical past, it will be use for better suggestions",
	FILE_USER_MUSICAL_PAST_ERROR_MESSAGE: "We couldn't get your musical past, please try later",

	// Security Controller
	FILE_SECURITY_FAILED: "An error occured during the request",

	// Album Show View
	DISPLAY_ALBUM_BY_LABEL: "By ",
	DISPLAY_ALBUM_ADD_TO_CART: "Add to cart",
	DISPLAY_ALBUM_SEND_COMMENT_BUTTON: "Comment",

	// Battle Index View
	DISPLAY_BATTLE_LIST_LABEL: "List of battles",
	DISPLAY_BATTLE_LINK_TO_SHOW_LABEL: "Page of the battle",

	// Battle Show View
	DISPLAY_BATTLE_TOP_LABEL: "Top music of ",
	DISPLAY_BATTLE_NO_MUSIC_LABEL: "No music yet !",
	DISPLAY_BATTLE_THEY_VOTED_LABEL: "They voted for an artist...",

	// Explorer Index View
	DISPLAY_EXPLORER_INDEX_LABEL: "Index",
	DISPLAY_EXPLORER_INFLUENCE_CHOOSE_LABEL: "Choose an influence",
	DISPLAY_EXPLORER_AMBIANCE_CHOOSE_LABEL: "Choose an ambiance",
	DISPLAY_EXPLORER_GENRE_LABEL: "genres",

	// Listening Index View
	DISPLAY_LISTENING_ERROR_GEOLOCATION_LABEL: "Your browser doesn't support geolocation, please update it or choose another one",
	DISPLAY_LISTENING_WAITING_LABEL: "Waiting...",
	DISPLAY_LISTENING_INFORMATION_LABEL: "We are getting your position, if you didn't already allowed your browser to give us your location, you need to accept to access to this feature.",
	DISPLAY_LISTENING_RANGE_LABEL: "You search in a range of :",

	// Notification Index View
	DISPLAY_NOTIFICATION_NEW_LABEL: "New Notifications",
	DISPLAY_NOTIFICATION_OLD_LABEL: "Old Notifications",
	DISPLAY_NOTIFICATION_MORE_LABEL: "See more...",

	// Player view
	DISPLAY_PLAYER_CURRENT_PLAYLIST_LABEL: "Current Playlist",
	DISPLAY_PLAYER_CLEAN_LABEL: "Clean",
	DISPLAY_PLAYER_MORE_LABEL: "More...",
	DISPLAY_PLAYER_LESS_LABEL: "Less...",
	DISPLAY_PLAYER_GEOLOCATION_LABEL: "Geolocation",
	DISPLAY_PLAYER_TITLE_LABEL: "Title",
	DISPLAY_PLAYER_PRICE_LABEL: "Price",
	DISPLAY_PLAYER_DURATION_LABEL: "Duration",
	DISPLAY_PLAYER_ALBUM_LABEL: "Album",
	DISPLAY_PLAYER_ALBUM_LINK_LABEL: "Link to the album page",
	DISPLAY_PLAYER_YOUR_PLAYLIST_LABEL: "Your playlists",
	DISPLAY_PLAYER_NAME_LABEL: "Name",
	DISPLAY_PLAYER_NEW_PLAYLIST_PLACEHOLDER: "New Playlist",
	DISPLAY_PLAYER_SAVE_NEW_PLAYLIST_LABEL: "Save",
	DISPLAY_PLAYER_SHARE_LABEL: "Share",

	// Playlist view
	DISPLAY_PLAYLIST_EMPTY_LABEL: "This playlist is empty",
	DISPLAY_PLAYLIST_FROM_LABEL: "From",
	DISPLAY_PLAYLIST_MUSICS_LABEL: "musics",
	DISPLAY_PLAYLIST_LISTEN_LABEL: "Listen",
	DISPLAY_PLAYLIST_NEW_PLAYLIST_LABEL: "Save as...",
	DISPLAY_PLAYLIST_SHARE_LABEL: "Share",

	// Search view
	DISPLAY_SEARCH_FILTERS_LABEL: "Filters",
	DISPLAY_SEARCH_ALL_FILTER_LABEL: "All",
	DISPLAY_SEARCH_USER_FILTER_LABEL: "Users",
	DISPLAY_SEARCH_ARTIST_FILTER_LABEL: "Artists",
	DISPLAY_SEARCH_ALBUM_FILTER_LABEL: "Albums",
	DISPLAY_SEARCH_MUSIC_FILTER_LABEL: "Musics",
	DISPLAY_SEARCH_PACK_FILTER_LABEL: "Packs",
	DISPLAY_SEARCH_SEARCH_LABEL: "Search",
	DISPLAY_SEARCH_NOTHING_LABEL: "Nothing found",
	DISPLAY_SEARCH_ALBUM_FROM_LABEL: "From the album",
	DISPLAY_SEARCH_BY_LABEL: "By",

	// User _form view
	DISPLAY_USER_FORM_IMAGES_LABEL: "Images",
	DISPLAY_USER_FORM_AVATAR_LABEL: "Avatar",
	DISPLAY_USER_FORM_IMAGE_LOAD_LABEL: "Load an image",
	DISPLAY_USER_FORM_IMAGE_LABEL: "Image",
	DISPLAY_USER_FORM_BACKGROUND_LABEL: "Background",
	DISPLAY_USER_FORM_PUBLIC_INFO_LABEL: "Public informations",
	DISPLAY_USER_FORM_USERNAME_LABEL: "Username",
	DISPLAY_USER_FORM_EMAIL_LABEL: "Email",
	DISPLAY_USER_FORM_DESCRIPTION_LABEL: "Description",
	DISPLAY_USER_FORM_BIRTHDAY_LABEL: "Birthday",
	DISPLAY_USER_FORM_FB_LABEL: "Facebook",
	DISPLAY_USER_FORM_TWITTER_LABEL: "Twitter",
	DISPLAY_USER_FORM_GPLUS_LABEL: "Google Plus",
	DISPLAY_USER_FORM_PERSO_INFO_LABEL: "Personnal informations",
	DISPLAY_USER_FORM_FIRSTNAME_LABEL: "Firstname",
	DISPLAY_USER_FORM_LASTNAME_LABEL: "Lastname",
	DISPLAY_USER_FORM_PASSWORD_LABEL: "Password",
	DISPLAY_USER_FORM_PHONE_LABEL: "Phone",
	DISPLAY_USER_FORM_NEWSLETTER_LABEL: "Newsletter",
	DISPLAY_USER_FORM_LANGUAGE_LABEL: "Language",
	DISPLAY_USER_FORM_LINKS_LABEL: "Link your account allows you to connect thanks to it to SoonZik",
	DISPLAY_USER_FORM_FB_LINK_LABEL: "Link your account with Facebook :",
	DISPLAY_USER_FORM_FB_LOG_LABEL: "Login with Facebook",
	DISPLAY_USER_FORM_TWITTER_LINK_LABEL: "Link your account with Twitter :",
	DISPLAY_USER_FORM_TWITTER_LOG_LABEL: "Login with Twitter",
	DISPLAY_USER_FORM_GPLUS_LINK_LABEL: "Link your account with Google Plus :",
	DISPLAY_USER_FORM_GPLUS_LOG_LABEL: "Login with Google Plus",
	DISPLAY_USER_FORM_SOUNDCLOUD_LINK_LABEL: "Import your musical past from Soundcloud :",
	DISPLAY_USER_FORM_SOUNDCLOUD_LOG_LABEL: "Get your favorites on Soundcloud",
	DISPLAY_USER_FORM_LINKED_LABEL: "Your account is linked",
	DISPLAY_USER_FORM_NUMBER_LABEL: "Number in the street",
	DISPLAY_USER_FORM_COMPLEMENT_LABEL: "Complement",
	DISPLAY_USER_FORM_STREET_LABEL: "Street",
	DISPLAY_USER_FORM_CITY_LABEL: "City",
	DISPLAY_USER_FORM_COUNTRY_LABEL: "Country",
	DISPLAY_USER_FORM_ZIPCODE_LABEL: "Zipcode",
	DISPLAY_USER_SAVE_BUTTON: "Save",

	// User show view
	DISPLAY_USER_ARTIST_TOP_LABEL: "Top Songs",
	DISPLAY_USER_TITLE_SONG_LABEL: "Title",
	DISPLAY_USER_DURATION_SONG_LABEL: "Duration",
	DISPLAY_USER_PRICE_SONG_LABEL: "Price",
	DISPLAY_USER_RATE_AV_SONG_LABEL: "Rate (average)",
	DISPLAY_USER_ADD_PLAYLIST_LABEL: "Add to playlist",
	DISPLAY_USER_ADD_BUTTON: "Add",
	DISPLAY_USER_LISTEN_LABEL: "Listen",
	DISPLAY_USER_CLOSE_BUTTON: "Close",
	DISPLAY_USER_ALBUMS_LABEL: "Albums",
	DISPLAY_USER_PACKS_LABEL: "Packs",
	DISPLAY_USER_TWEETS_LABEL: "Tweets",
	DISPLAY_USER_TWEETS_CHARACTERS_LABEL: "characters left",
	DISPLAY_USER_ANSWER_LABEL: "Answer",
	DISPLAY_USER_MUSICS_LABEL: "musics",
	DISPLAY_USER_PLAYLIST_DURATION_LABEL: "Duration (total)",
	DISPLAY_USER_MORE_LABEL: "More...",
	DISPLAY_USER_FOLLOWERS_LABEL: "Followers",
	DISPLAY_USER_FOLLOW_LABEL: "Follow",
	DISPLAY_USER_FOLLOWING_LABEL: "Following",
	DISPLAY_USER_ADDFRIEND_LABEL: "Add friend",
	DISPLAY_USER_DELFRIEND_LABEL: "Delete friend",

	// Chat view
	DISPLAY_CHAT_PLACEHOLDER_INPUT_LABEL: "Search a friend",
	DISPLAY_CHAT_CONNECTED_LABEL: "Connected friend",
	DISPLAY_CHAT_DISCONNECTED_LABEL: "Disconnected friend",

	// Concert Index view
	DISPLAY_CONCERT_TOO_MANY_PAGE_LABEL: "The page you asked for is not available",
	DISPLAY_CONCERT_CONCERT_OF_LABEL: "Concert of ",
	DISPLAY_CONCERT_LINK_LABEL: "Link : ",
	DISPLAY_CONCERT_NO_LINK_LABEL: "No link",
	DISPLAY_CONCERT_ADDRESS_LABEL: "Address : ",
	DISPLAY_CONCERT_ARTIST_FILTER_LABEL: "Artist : ",
	DISPLAY_CONCERT_COUNTRY_FILTER_LABEL: "Country : ",

	// Concert Controller
	FILE_CONCERT_FIND_CONCERT_ERROR_MESSAGE: "An error occured while loading the concerts",

	// Discotheque Index view
	DISPLAY_DISCOTHEQUE_NOTHING_LABEL: "Nothing found",
	DISPLAY_DISCOTHEQUE_MUSIC_LABEL: "Your musics",
	DISPLAY_DISCOTHEQUE_ALBUM_LABEL: "Your albums",
	DISPLAY_DISCOTHEQUE_PACK_LABEL: "Your packs",

	// Discotheque Controller
	FILE_DISCOTHEQUE_GET_NOTES_ERROR_MESSAGE: "An error occured while getting the notes",
	FILE_DISCOTHEQUE_GET_MUSICS_ERROR_MESSAGE: "An error occured while getting your musics",

	// User signup view
	DISPLAY_SIGNUP_SIGNUP_LABEL: "Sign up",
	DISPLAY_SIGNUP_PUBLIC_INFO_LABEL: "Public informations",
	DISPLAY_SIGNUP_PERSO_INFO_LABEL: "Personal informations",
	DISPLAY_SIGNUP_USERNAME_LABEL: "Username *",
	DISPLAY_SIGNUP_DESCRIPTION_LABEL: "Description",
	DISPLAY_SIGNUP_BIRTHDAY_LABEL: "Birthday *",
	DISPLAY_SIGNUP_FACEBOOK_LABEL: "Facebook",
	DISPLAY_SIGNUP_TWITTER_LABEL: "Twitter",
	DISPLAY_SIGNUP_GPLUS_LABEL: "Google Plus",
	DISPLAY_SIGNUP_FIRSTNAME_LABEL: "First name *",
	DISPLAY_SIGNUP_LASTNAME_LABEL: "Last name *",
	DISPLAY_SIGNUP_PASSWORD_LABEL: "Password *",
	DISPLAY_SIGNUP_EMAIL_LABEL: "Email *",
	DISPLAY_SIGNUP_PHONE_LABEL: "Phone Number",
	DISPLAY_SIGNUP_NEWSLETTER_LABEL: "Newsletter",

  // Cart view
  DISPLAY_CART_INDEX: "Cart",
  DISPLAY_CART_BUY: "Buy your cart",

  DISPLAY_CART_ALBUM: "Albums",
  DISPLAY_CART_MUSIC: "Musics",
  DISPLAY_CART_EMPTY: "Your cart is empty",
  DISPLAY_CART_DELETE: "Delete",
  DISPLAY_CART_PRICE: "Price",
  DISPLAY_CART_TOTAL: "Total",


  // Cart Controller
  FILE_CART_LOAD_ERROR_MESSAGE: "An error occured while getting the cart",
  FILE_CART_DELETE_ITEM_ERROR_MESSAGE: "An error occured while destroying an item in cart",
  FILE_CART_DELETE_SUCCESS_MESSAGE: "Item is successfuly delete",
  FILE_CART_SUCCESS_BUY_CART_MESSAGE: "Cart is successfuly buy",
  FILE_CART_BUY_ERROR_MESSAGE: "An error occured while buying the cart",

  // Friends view
  DISPLAY_FRIENDS_LABEL: "Friends",

  // Friends Controller
  FILE_FRIEND_LOAD_FRIENDS_ERROR_MESSAGE: "An error occured while loading your friends",

  // News view
  DISPLAY_NEWS_LABEL: "News",
  DISPLAY_NEWS_SHOW_MORE: "Show More",
  DISPLAY_NEWS_COMMENT_SEND: "Send",

  // News Controller
  FILE_NEWS_LOAD_COMMENT_ERROR_MESSAGE: "Error while loading commentaries",
  FILE_NEWS_SEND_COMMENT_ERROR_MESSAGE: "Error while saving your comment, please try later",
  FILE_NEWS_LOAD_ERROR_MESSAGE: "Error while loading news",
  FILE_NEWS_LOAD_ONE_NEWS_ERROR_MESSAGE: "The page you asked is not available",

  // Packs view
  DISPLAY_PACK_LABEL: "Packs of the moment",
  DISPLAY_PACK_TIMELEFT: "Time left",
  DISPLAY_PACK_AVERAGE: "Average",
  DISPLAY_PACK_YEAR_ALBUM: "Release",
  DISPLAY_PACK_ARTIST_NAME: "Artist",
  DISPLAY_PACK_DEV_NAME: "Soonzik",
  DISPLAY_PACK_ASSOCIATION_NAME: "Association",
  DISPLAY_PACK_BUY_PACK: "Buy this pack",
  DISPLAY_PACK_TOTAL_PACK: "Total",
  DISPLAY_PACK_GIFT_LABEL: "Gift for : ",

  DISPLAY_PACK_DEFINE_PRICE: "Define your price",

  // Packs Controller
  FILE_PACK_LOAD_ERROR_MESSAGE: "Error while loading packs",
  FILE_PACK_LOAD_ONE_PACK_ERROR_MESSAGE: "The page you asked is not available",
  FILE_PACK_BUY_PACK_ERROR_MESSAGE: "Error while buying your cart",

  // Index view
  DISPLAY_INDEX_NEWS_SEE_MORE: "See more news",
  DISPLAY_INDEX_PACKS_SEE_MORE: "See more packs",
  DISPLAY_INDEX_BATTLES_SEE_MORE: "See more battles",
  DISPLAY_INDEX_SWEET_LABEL: "Sweets",
  DISPLAY_INDEX_ACTIVITY_LABEL: "Activities",
  DISPLAY_INDEX_INTERACTION_LABEL: "Interactions",
  DISPLAY_INDEX_NO_SWEET_LABEL: "No sweet to show",
  DISPLAY_INDEX_ANSWER_LABEL: "Answer",
  DISPLAY_INDEX_CHARACTER_LEFT_LABEL: "characters left",
  DISPLAY_INDEX_LAST_NEWS_LABEL: "The last news",
  DISPLAY_INDEX_LAST_PACKS_LABEL: "The last packs",
  DISPLAY_INDEX_LAST_BATTLES_LABEL: "The last battles",
  DISPLAY_INDEX_PAY_MORE_LABEL_PART_ONE: "Pay",
  DISPLAY_INDEX_PAY_MORE_LABEL_PART_TWO: "$ or more to unlock",
  DISPLAY_INDEX_SUGGESTION_LABEL: "Suggestions",
  DISPLAY_INDEX_BATTLE_PAGE_LABEL: "Access to the battle",
  DISPLAY_INDEX_PACK_PAGE_LABEL: "Access to the pack",

  // Index Controller
  FILE_INDEX_NEWS_LOAD_ERROR_MESSAGE: "An error occured while loading the news",
  FILE_INDEX_PACKS_LOAD_ERROR_MESSAGE: "An error occured while loading the packs",
  FILE_INDEX_BATTLES_LOAD_ERROR_MESSAGE: "An error occured while loading the battles",
  FILE_INDEX_PROFILE_LOAD_ERROR_MESSAGE: "An error occured while loading the profile of an artist",
  FILE_INDEX_FLUX_LOAD_ERROR_MESSAGE: "An error occured while loading your activities",
  FILE_INDEX_SUGGESTION_LOAD_ERROR_MESSAGE: "An error occured while loading your suggestions",

  // Sign in View
  DISPLAY_SIGNIN_MAIL_PLACEHOLDER: "Email address",
  DISPLAY_SIGNIN_PASSWORD_PLACEHOLDER: "Password",
  DISPLAY_SIGNIN_REMEMBER_LABEL: "Remember me",
  DISPLAY_SIGNIN_PASSWORD_FORGOTTEN_LABEL: "Password forgotten ?",
  DISPLAY_SIGNIN_SIGNIN_LABEL: "Sign in",
  DISPLAY_SIGNIN_NOT_SIGNUP_LABEL: "Not registered ?",
  DISPLAY_SIGNIN_SIGNUP_LABEL: "Sign up",
  DISPLAY_SIGNIN_CONFIRM_NOT_RECEIVED_LABEL: "Account confirmation not received ?",
  DISPLAY_SIGNIN_SEND_LABEL: "Send",
  DISPLAY_SIGNIN_NEWPASSWORD_LABEL: "New password",
  DISPLAY_SIGNIN_CONFIRM_NEWPASSWORD_LABEL: "Confirm new password",

  // Commentaries view
  DISPLAY_COMMENTARY_TITLE_LABEL: "Commentaries",
  DISPLAY_NO_COMMENTARY_LABEL: "No commentaries",

  // Application
  FILE_APP_PLAYLIST_NOT_FOUND_ERROR_MESSAGE: "An error occured while adding the playlist : ",
  FILE_APP_LIKE_ERROR_MESSAGE: "Une erreur s'est produite lors de la mention 'J'aime'",
  FILE_APP_UNLIKE_ERROR_MESSAGE: "Une erreur s'est produite lors du retrait de la mention 'J'aime'",

  // Tooltip Controller
	FILE_TOOLTIP_ADD_PLAYLIST_ERROR_MESSAGE: "An error occured while adding a music to a playlist",
	FILE_TOOLTIP_SAVE_PLAYLIST_ERROR_MESSAGE: "Error while saving a new playlist",
	FILE_TOOLTIP_DELETE_PLAYLIST_ERROR_MESSAGE: "Error while deleting the playlist : ",

  // Tooltip View
	DISPLAY_TOOLTIP_LISTEN_LABEL: "Listen",
	DISPLAY_TOOLTIP_ADD_CURRENT_PLAYLIST_LABEL: "Add to the current playlist",
	DISPLAY_TOOLTIP_ADD_TO_PLAYLIST_LABEL: "Add to a playlist",
	DISPLAY_TOOLTIP_REPLACE_PLAYLIST_LABEL: "Replace the current playlist",
	DISPLAY_TOOLTIP_CLOSE_LABEL: "Close",
	DISPLAY_TOOLTIP_BACK_LABEL: "Back",
	DISPLAY_TOOLTIP_SHARE_LABEL: "Share",
	DISPLAY_TOOLTIP_NEW_PLAYLIST_LABEL: "New playlist",
	DISPLAY_TOOLTIP_NAME_LABEL: "Name : ",
	DISPLAY_TOOLTIP_SAVE_BUTTON: "Save",
	DISPLAY_TOOLTIP_SURE_DELETE_LABEL: "Are you sure ?",
	DISPLAY_TOOLTIP_YES_LABEL: "Yes",
	DISPLAY_TOOLTIP_NO_LABEL: "No",

	// Feedback View
	DISPLAY_FEEDBACK_TITLE_LABEL: "Feedbacks",
	DISPLAY_FEEDBACK_EMAIL_LABEL: "Email",
	DISPLAY_FEEDBACK_TYPE_OBJ_LABEL: "Type of feedback",
	DISPLAY_FEEDBACK_OBJECT_LABEL: "Object",
	DISPLAY_FEEDBACK_TEXT_LABEL: "Text",
	DISPLAY_FEEDBACK_SAVE_LABEL: "Send",
	DISPLAY_FEEDBACK_TYPE_OBJ_BUG_LABEL: "Bug on the website",
	DISPLAY_FEEDBACK_TYPE_OBJ_PAYMENT_LABEL: "Payment issue",
	DISPLAY_FEEDBACK_TYPE_OBJ_ACCOUNT_LABEL: "Account issue",
	DISPLAY_FEEDBACK_TYPE_OBJ_OTHER_LABEL: "Other",
	DISPLAY_FEEDBACK_SEND_MSG: "The feedback has been send. Thanks for your support",
}
