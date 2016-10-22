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
	DISPLAY_MENU_PROFILE_EDITION_LABEL: "Editer son profil",
	DISPLAY_MENU_NEWS_LABEL: "News",
	DISPLAY_MENU_EXPLORER_LABEL: "Explorer",
	DISPLAY_MENU_PACKS_LABEL: "Packs",
	DISPLAY_MENU_BATTLES_LABEL: "Duels",
	DISPLAY_MENU_FRIENDS_LABEL: "Amis",
	DISPLAY_MENU_LISTENING_LABEL: "Listening",
	DISPLAY_MENU_CONCERT_LABEL: "Concerts",
	DISPLAY_MENU_CART_LABEL: "Mon panier",
	DISPLAY_MENU_MUSIC_LABEL: "Ma musique",
	DISPLAY_MENU_FEEDBACK_LABEL: "Feedback",
	DISPLAY_MENU_SIGNUP_LABEL: "Inscription",
	DISPLAY_MENU_LOGIN_LABEL: "Connexion",
	DISPLAY_MENU_LOGOUT_LABEL: "Déconnexion",
	DISPLAY_MENU_SEARCH_PLACEHOLDER: "Chercher des utilisateurs, musiques, albums...",

	// Header Controller
	FILE_MENU_LANGUAGE_ERROR_LABEL: "Une erreur s'est produite lors du changement de langue",

	// Album Controller
	FILE_ALBUM_ADD_ALBUM_MESSAGE: "L'album a bien été ajouté au panier",
	FILE_ALBUM_ADD_ALBUM_ERROR_MESSAGE: "Une erreur s'est produite lors de l'ajout au panier",
	FILE_ALBUM_ADD_SONG_MESSAGE: "La musique a bien été ajouté au panier",
	FILE_ALBUM_ADD_SONG_ERROR_MESSAGE: "Une erreur s'est produite lors de l'ajout au panier",
	FILE_ALBUM_GET_NOTES_ERROR_MESSAGE: "Une erreur s'est produite au chargement des notes",
	FILE_ALBUM_GET_ALBUM_ERROR_MESSAGE: "Une erreur s'est produite au chargement d'un album",
	FILE_ALBUM_SET_NOTE_ERROR_MESSAGE: "Une erreur s'est produite à la notation d'une musique",
	FILE_ALBUM_LOAD_COMMENT_ERROR_MESSAGE: "Une erreur s'est produite au chargement des commentaires",
	FILE_ALBUM_SEND_COMMENT_ERROR_MESSAGE: "Une erreur s'est produite à la sauvegarde de votre commentaire",

	// Battle Controller
	FILE_BATTLE_LOAD_BATTLE_ERROR_MESSAGE: "Une erreur s'est produite au chargement de la page",
	FILE_BATTLE_LOAD_ARTIST_ONE_ERROR_MESSAGE: "Une erreur s'est produite au chargement du profil du premier artiste",
	FILE_BATTLE_LOAD_ARTIST_TWO_ERROR_MESSAGE: "Une erreur s'est produite au chargement du profil du deuxieme artiste",
	FILE_BATTLE_NEED_AUTHENTICATION_ERROR_MESSAGE: "Vous devez être authentifié pour cette action",
	FILE_BATTLE_VOTE_ERROR_MESSAGE: "Une erreur s'est produite à la sauvegarde de votre vote",
	FILE_BATTLE_ALREADY_VOTED_ERROR_MESSAGE: "Cette action est impossible : Vous avez déjà voté pour cet artiste",
	FILE_BATTLE_VOTETEXT_LABEL: "Vote",
	FILE_BATTLE_VOTEDTEXT_LABEL: "Vous avez voté pour cet artist",
	FILE_BATTLE_CANCEL_TEXT_LABEL: "Annulez votre précédent vote pour voter pour cet artiste !",

	// Chat Controller
	FILE_CHAT_GET_MESSAGE_ERROR_MESSAGE: "Une erreur s'est produite au chargement de la page",

	// Explorer Controller
	FILE_EXPLORER_GET_INFLUENCES_ERROR_MESSAGE: "Une erreur s'est produite au chargement des influences",
	FILE_EXPLORER_GET_AMBIANCES_ERROR_MESSAGE: "Une erreur s'est produite au chargement des ambiances",
	FILE_EXPLORER_GET_AMBIANCE_ERROR_MESSAGE: "Une erreur s'est produite au chargement de l'ambiance",
	FILE_EXPLORER_GET_GENRE_ERROR_MESSAGE: "Une erreur s'est produite des genres",

	// Listening Controller
	FILE_LISTENING_AROUND_ERROR_MESSAGE: "Une erreur s'est produite au chargement des musiques autour de vous",
	FILE_LISTENING_INPOPUP_LISTENED_LABEL: " écouté par ",

	// Notification Controller
	FILE_NOTIFICATION_TWEET_NOTIF_MESSAGE: " a tweeté à propos de vous",
	FILE_NOTIFICATION_FRIEND_NOTIF_MESSAGE: " vous a ajouté en ami",
	FILE_NOTIFICATION_FOLLOW_NOTIF_MESSAGE: " vous suit",
	FILE_NOTIFICATION_ASREAD_NOTIF_ERROR_MESSAGE: "Impossible de marquer vos notifications comme lues",
	FILE_NOTIFICATION_MORE_NOTIF_ERROR_MESSAGE: "Une erreur s'est produite à la récupération d'anciennes notifications",

	// Player Controller
	FILE_PLAYER_FIND_PLAYLIST_ERROR_MESSAGE: "Erreur : Impossible de récupérer vos listes de lecture",
	FILE_PLAYER_REMOVE_FROM_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à la suppression d'une musique d'une liste de lecture",
	FILE_PLAYER_SAVE_IN_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à la sauvegarde d'une nouvelle musique dans une liste de lecture",
	FILE_PLAYER_PLAY_MUSIC_ERROR_MESSAGE: "Une erreur s'est produite au chargement de la musique : ",
	FILE_PLAYER_GEOLOC_MUSIC_ERROR_MESSAGE: "Impossible d'ajouter cette musique au module de géolocalisation",
	FILE_PLAYER_DELETE_PLAYLIST_ERROR_MESSAGE: "Une erreur est survenue lors de la suppression de la playlist ",

	// Playlist Controller
	FILE_PLAYLIST_BAD_ARGUMENT_ERROR_MESSAGE: "Impossible de charger cette liste de lecture",
	FILE_PLAYLIST_FIND_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à la suppression de la liste de lecture : ",
	FILE_PLAYLIST_GET_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite au chargement des informations de la liste de lecture",
	FILE_PLAYLIST_GET_MUSIC_ERROR_MESSAGE: "Une erreur s'est produite au chargement des informations de la musique numéro ",
	FILE_PLAYLIST_TMP_NAME_LABEL: "Playlist temporaire",
	FILE_PLAYLIST_NEW_MUSIC_ERROR_MESSAGE: "Une erreur s'est produite à la sauvegarde d'une musique dans la liste de lecture",

	// Search Controller
	FILE_SEARCH_REQUEST_ERROR_MESSAGE: "Une erreur s'est produite au chargement des résultats de votre recherche",

	// User Controller
	FILE_USER_MONTHS_INFORMATION: ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Décembre"],
	FILE_USER_FIND_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à la suppression de la liste de lecture : ",
	FILE_USER_GET_NOTES_ERROR_MESSAGE: "Une erreur s'est produite au chargement des notes",
	FILE_USER_GET_FOLLOWERS_ERROR_MESSAGE: "Une erreur s'est produite au chargement des personnes qui suivent ce profil",
	FILE_USER_GET_FOLLOWS_ERROR_MESSAGE: "Une erreur s'est produite au chargement des personnes suivies par ce profil",
	FILE_USER_GET_FRIENDS_ERROR_MESSAGE: "Une erreur s'est produite au chargement des amis de ce profil",
	FILE_USER_GET_PLAYLISTS_ERROR_MESSAGE: "Une erreur s'est produite au chargement des listes de lecture de ce profil",
	FILE_USER_PROFILE_ERROR_MESSAGE: "Une erreur s'est produite au chargement de ce profil",
	FILE_USER_EDITION_ERROR_MESSAGE: "Vous ne pouvez pas éditer ce profil : ce n'est pas le votre",
	FILE_USER_UPDATE_SUCCESS_MESSAGE: "Profil mis à jour avec succès",
	FILE_USER_ERROR_OCCURED_MESSAGE: "Une erreur s'est produite",
	FILE_USER_FOLLOW_ERROR_MESSAGE: "Une erreur s'est produite au moment de suivre cet utilisateur",
	FILE_USER_FRIEND_ERROR_MESSAGE: "Une erreur s'est produite à l'ajout d'un ami",
	FILE_USER_UNFOLLOW_ERROR_MESSAGE: "Une erreur s'est produite au moment de ne plus suivre cet utilisateur",
	FILE_USER_UNFFRIEND_ERROR_MESSAGE: "Une erreur s'est produite à la suppression d'un ami",
	FILE_USER_SAVE_TWEET_ERROR_MESSAGE: "Une erreur s'est produite à la sauvegarde du tweet",
	FILE_USER_TWEET_TOO_LONG_ERROR_MESSAGE: "Votre message est trop grand. La taille max. est de 140 caractères.",
	FILE_USER_SET_NOTE_ERROR_MESSAGE: "Une erreur s'est produite à la notation d'une musique",
	FILE_USER_NEED_LOGIN_ERROR_MESSAGE: "Vous devez être authentifié pour cette action",
	FILE_USER_ADD_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à l'ajout d'une musique dans la liste de lecture",
	FILE_USER_FB_LINKED_ERROR_MESSAGE: "Le compte Facebook est déjà lié à un autre compte SoonZik",
	FILE_USER_FB_LINK_ERROR_MESSAGE: "Impossible de lier ce compte à votre profil",
	FILE_USER_GOOGLE_LINKED_ERROR_MESSAGE: "Le compte google + est déjà lié à un autre compte SoonZik",
	FILE_USER_GOOGLE_LINK_ERROR_MESSAGE: "Impossible de lier ce compte à votre profil",
	FILE_USER_GOOGLE_CONNECTION_ERROR_MESSAGE: "Impossible de se connecter à Google Plus",
	FILE_USER_SOUNDCLOUD_CONNECTION_ERROR_MESSAGE: "Impossible de se connecter à Soundcloud",
	FILE_USER_MUSICAL_PAST_SUCCESS_MESSAGE: "Nous avons récupéré votre passé musical, il sera utilisé pour de meilleures suggestions",
	FILE_USER_MUSICAL_PAST_ERROR_MESSAGE: "Nous n'avons pas pu récupéré votre passé musical, ré-essayez ultérieurement",

	// Security Controller
	FILE_SECURITY_FAILED: "Une erreur s'est produite durant la requête",

	// Album Show View
	DISPLAY_ALBUM_BY_LABEL: "Par ",
	DISPLAY_ALBUM_ADD_TO_CART: "Ajouter au panier",
	DISPLAY_ALBUM_SEND_COMMENT_BUTTON: "Commenter",

	// Battle Index View
	DISPLAY_BATTLE_LIST_LABEL: "Liste des duels",
	DISPLAY_BATTLE_LINK_TO_SHOW_LABEL: "Page du duel",

	// Battle Show View
	DISPLAY_BATTLE_TOP_LABEL: "Top music de ",
	DISPLAY_BATTLE_NO_MUSIC_LABEL: "Aucune musique pour le moment !",
	DISPLAY_BATTLE_THEY_VOTED_LABEL: "Ils ont voté pour un artiste...",

	// Explorer Index View
	DISPLAY_EXPLORER_INDEX_LABEL: "Index",
	DISPLAY_EXPLORER_INFLUENCE_CHOOSE_LABEL: "Choisissez une influence",
	DISPLAY_EXPLORER_AMBIANCE_CHOOSE_LABEL: "Choisissez une ambiance",
	DISPLAY_EXPLORER_GENRE_LABEL: "genres",

	// Listening Index View
	DISPLAY_LISTENING_ERROR_GEOLOCATION_LABEL: "Votre navigateur ne supporte pas la géolocalisation, mettez le à jour ou choisissez en un autre.",
	DISPLAY_LISTENING_WAITING_LABEL: "Patientez...",
	DISPLAY_LISTENING_INFORMATION_LABEL: "Nous récupérons votre position, si vous n'avez pas encore autorisé votre navigateur à nous donner votre position, vous devez valider l'accès à cette fonctionnalité.",
	DISPLAY_LISTENING_RANGE_LABEL: "Vous cherchez dans un rayon de :",

	// Notification Index View
	DISPLAY_NOTIFICATION_NEW_LABEL: "Nouvelles Notifications",
	DISPLAY_NOTIFICATION_OLD_LABEL: "Anciennes Notifications",
	DISPLAY_NOTIFICATION_MORE_LABEL: "Voir plus...",

	// Player view
	DISPLAY_PLAYER_CURRENT_PLAYLIST_LABEL: "Liste de lecture courante",
	DISPLAY_PLAYER_CLEAN_LABEL: "Vider",
	DISPLAY_PLAYER_MORE_LABEL: "Plus...",
	DISPLAY_PLAYER_LESS_LABEL: "Moins...",
	DISPLAY_PLAYER_GEOLOCATION_LABEL: "Geolocalisation",
	DISPLAY_PLAYER_TITLE_LABEL: "Titre",
	DISPLAY_PLAYER_PRICE_LABEL: "Prix",
	DISPLAY_PLAYER_DURATION_LABEL: "Durée",
	DISPLAY_PLAYER_ALBUM_LABEL: "Album",
	DISPLAY_PLAYER_ALBUM_LINK_LABEL: "Lien vers la page album",
	DISPLAY_PLAYER_YOUR_PLAYLIST_LABEL: "Vos listes de lecture",
	DISPLAY_PLAYER_NAME_LABEL: "Nom",
	DISPLAY_PLAYER_NEW_PLAYLIST_PLACEHOLDER: "Nouvelle playlist",

	// Playlist view
	DISPLAY_PLAYLIST_EMPTY_LABEL: "Cette liste de lecture est vide",
	DISPLAY_PLAYLIST_FROM_LABEL: "De",
	DISPLAY_PLAYLIST_MUSICS_LABEL: "musiques",
	DISPLAY_PLAYLIST_LISTEN_LABEL: "Ecouter",
	DISPLAY_PLAYLIST_NEW_PLAYLIST_LABEL: "Sauvegarder sous...",
	DISPLAY_PLAYLIST_SHARE_LABEL: "Partager",

	// Search view
	DISPLAY_SEARCH_FILTERS_LABEL: "Filtres",
	DISPLAY_SEARCH_ALL_FILTER_LABEL: "Tout",
	DISPLAY_SEARCH_USER_FILTER_LABEL: "Utilisateurs",
	DISPLAY_SEARCH_ARTIST_FILTER_LABEL: "Artistes",
	DISPLAY_SEARCH_ALBUM_FILTER_LABEL: "Albums",
	DISPLAY_SEARCH_MUSIC_FILTER_LABEL: "Musiques",
	DISPLAY_SEARCH_PACK_FILTER_LABEL: "Packs",
	DISPLAY_SEARCH_SEARCH_LABEL: "Chercher",
	DISPLAY_SEARCH_NOTHING_LABEL: "Rien trouvé",
	DISPLAY_SEARCH_ALBUM_FROM_LABEL: "De l'album",
	DISPLAY_SEARCH_BY_LABEL: "Par",

	// User _form view
	DISPLAY_USER_FORM_IMAGES_LABEL: "Images",
	DISPLAY_USER_FORM_AVATAR_LABEL: "Avatar",
	DISPLAY_USER_FORM_IMAGE_LOAD_LABEL: "Charger une image",
	DISPLAY_USER_FORM_IMAGE_LABEL: "Image",
	DISPLAY_USER_FORM_BACKGROUND_LABEL: "Arrière plan",
	DISPLAY_USER_FORM_PUBLIC_INFO_LABEL: "Informations publiques",
	DISPLAY_USER_FORM_USERNAME_LABEL: "Pseudo",
	DISPLAY_USER_FORM_EMAIL_LABEL: "Email",
	DISPLAY_USER_FORM_DESCRIPTION_LABEL: "Description",
	DISPLAY_USER_FORM_BIRTHDAY_LABEL: "Anniversaire",
	DISPLAY_USER_FORM_FB_LABEL: "Facebook",
	DISPLAY_USER_FORM_TWITTER_LABEL: "Twitter",
	DISPLAY_USER_FORM_GPLUS_LABEL: "Google Plus",
	DISPLAY_USER_FORM_PERSO_INFO_LABEL: "Informations personnelles",
	DISPLAY_USER_FORM_FIRSTNAME_LABEL: "Prénom",
	DISPLAY_USER_FORM_LASTNAME_LABEL: "Nom",
	DISPLAY_USER_FORM_PASSWORD_LABEL: "Mot de passe",
	DISPLAY_USER_FORM_PHONE_LABEL: "Téléphone",
	DISPLAY_USER_FORM_NEWSLETTER_LABEL: "Newsletter",
	DISPLAY_USER_FORM_LANGUAGE_LABEL: "Langage",
	DISPLAY_USER_FORM_LINKS_LABEL: "Lier votre compte vous permez de vous connecter à SoonZik grâce à ce dernier",
	DISPLAY_USER_FORM_FB_LINK_LABEL: "Lier son compte avec Facebook :",
	DISPLAY_USER_FORM_FB_LOG_LABEL: "Connexion avec Facebook",
	DISPLAY_USER_FORM_TWITTER_LINK_LABEL: "Lier son compte avec Twitter :",
	DISPLAY_USER_FORM_TWITTER_LOG_LABEL: "Connexion avec Twitter",
	DISPLAY_USER_FORM_GPLUS_LINK_LABEL: "Lier son compte avec Google Plus :",
	DISPLAY_USER_FORM_GPLUS_LOG_LABEL: "Connexion avec Google Plus",
	DISPLAY_USER_FORM_SOUNDCLOUD_LINK_LABEL: "Importer votre passé musical de Soundcloud :",
	DISPLAY_USER_FORM_SOUNDCLOUD_LOG_LABEL: "Récupérer ses favoris sur Soundcloud",
	DISPLAY_USER_FORM_LINKED_LABEL: "Votre compte est lié",
	DISPLAY_USER_FORM_NUMBER_LABEL: "Numéro de rue",
	DISPLAY_USER_FORM_COMPLEMENT_LABEL: "Complement",
	DISPLAY_USER_FORM_STREET_LABEL: "Rue",
	DISPLAY_USER_FORM_CITY_LABEL: "Ville",
	DISPLAY_USER_FORM_COUNTRY_LABEL: "Pays",
	DISPLAY_USER_FORM_ZIPCODE_LABEL: "Code Postal",
	DISPLAY_USER_SAVE_BUTTON: "Sauvegarder",

	// User show view
	DISPLAY_USER_ARTIST_TOP_LABEL: "Top Musiques",
	DISPLAY_USER_TITLE_SONG_LABEL: "Titre",
	DISPLAY_USER_DURATION_SONG_LABEL: "Durée",
	DISPLAY_USER_PRICE_SONG_LABEL: "Price",
	DISPLAY_USER_RATE_AV_SONG_LABEL: "Note (moyenne)",
	DISPLAY_USER_ADD_PLAYLIST_LABEL: "Ajouter à la liste de lecture",
	DISPLAY_USER_ADD_BUTTON: "Ajouter",
	DISPLAY_USER_LISTEN_LABEL: "Ecouter",
	DISPLAY_USER_CLOSE_BUTTON: "Fermer",
	DISPLAY_USER_ALBUMS_LABEL: "Albums",
	DISPLAY_USER_PACKS_LABEL: "Packs",
	DISPLAY_USER_TWEETS_LABEL: "Tweets",
	DISPLAY_USER_TWEETS_CHARACTERS_LABEL: "caractères restants",
	DISPLAY_USER_ANSWER_LABEL: "Répondre",
	DISPLAY_USER_MUSICS_LABEL: "musiques",
	DISPLAY_USER_PLAYLIST_DURATION_LABEL: "Durée (total)",
	DISPLAY_USER_MORE_LABEL: "Plus...",
	DISPLAY_USER_FOLLOWERS_LABEL: "Followers",
	DISPLAY_USER_FOLLOW_LABEL: "Suivre",
	DISPLAY_USER_FOLLOWING_LABEL: "Suivi",
	DISPLAY_USER_ADDFRIEND_LABEL: "Ajouter en ami",
	DISPLAY_USER_DELFRIEND_LABEL: "Supprimer des amis",

	// Chat view
	DISPLAY_CHAT_PLACEHOLDER_INPUT_LABEL: "Chercher un ami",
	DISPLAY_CHAT_CONNECTED_LABEL: "Amis connectés",
	DISPLAY_CHAT_DISCONNECTED_LABEL: "Amis déconnectés",

	// Concert Index view
	DISPLAY_CONCERT_TOO_MANY_PAGE_LABEL: "La page demandée n'existe pas",
	DISPLAY_CONCERT_CONCERT_OF_LABEL: "Concert de ",
	DISPLAY_CONCERT_LINK_LABEL: "Lien : ",
	DISPLAY_CONCERT_NO_LINK_LABEL: "Aucun lien",
	DISPLAY_CONCERT_ADDRESS_LABEL: "Adresse : ",
	DISPLAY_CONCERT_ARTIST_FILTER_LABEL: "Artiste : ",
	DISPLAY_CONCERT_COUNTRY_FILTER_LABEL: "Pays : ",

	// Concert Controller
	FILE_CONCERT_FIND_CONCERT_ERROR_MESSAGE: "Une erreur s'est produite lors du chargement des concerts",

	// Discotheque Index view
	DISPLAY_DISCOTHEQUE_NOTHING_LABEL: "Rien n'est disponible",
	DISPLAY_DISCOTHEQUE_MUSIC_LABEL: "Vos musiques",
	DISPLAY_DISCOTHEQUE_ALBUM_LABEL: "Vos albums",
	DISPLAY_DISCOTHEQUE_PACK_LABEL: "Vos packs",

	// Discotheque Controller
	FILE_DISCOTHEQUE_GET_NOTES_ERROR_MESSAGE: "Une erreur s'est produite à la récupération des notes",
	FILE_DISCOTHEQUE_GET_MUSICS_ERROR_MESSAGE: "Une erreur s'est produite au chargement de vos musiques",

	// User signup view
	DISPLAY_SIGNUP_SIGNUP_LABEL: "Inscription",
	DISPLAY_SIGNUP_PUBLIC_INFO_LABEL: "Informations publiques",
	DISPLAY_SIGNUP_PERSO_INFO_LABEL: "Informations personnelles",
	DISPLAY_SIGNUP_USERNAME_LABEL: "Pseudonyme *",
	DISPLAY_SIGNUP_DESCRIPTION_LABEL: "Description",
	DISPLAY_SIGNUP_BIRTHDAY_LABEL: "Date de naissance *",
	DISPLAY_SIGNUP_FACEBOOK_LABEL: "Facebook",
	DISPLAY_SIGNUP_TWITTER_LABEL: "Twitter",
	DISPLAY_SIGNUP_GPLUS_LABEL: "Google Plus",
	DISPLAY_SIGNUP_FIRSTNAME_LABEL: "Prénom *",
	DISPLAY_SIGNUP_LASTNAME_LABEL: "Nom *",
	DISPLAY_SIGNUP_PASSWORD_LABEL: "Mot de passe *",
	DISPLAY_SIGNUP_EMAIL_LABEL: "Email *",
	DISPLAY_SIGNUP_PHONE_LABEL: "Numéro de téléphone",
	DISPLAY_SIGNUP_NEWSLETTER_LABEL: "Newsletter",

  // Cart view
  DISPLAY_CART_INDEX: "Panier",
  DISPLAY_CART_BUY: "Acheter le panier",

  DISPLAY_CART_ALBUM: "Albums",
  DISPLAY_CART_MUSIC: "Musiques",
  DISPLAY_CART_EMPTY: "Votre panier est vide",
  DISPLAY_CART_DELETE: "Supprimer",
  DISPLAY_CART_PRICE: "Prix",
  DISPLAY_CART_TOTAL: "Total",


  // Cart Controller
  FILE_CART_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors de la recupération du panier",
  FILE_CART_DELETE_ITEM_ERROR_MESSAGE: "Une error s'est produite lors de la destruction du panier",
  FILE_CART_DELETE_ERROR_MESSAGE: "Une erreur s'est produite lors de la destruction du panier",
  FILE_CART_SUCCESS_BUY_CART_MESSAGE: "Votre panier a bien été acheté",
  FILE_CART_BUY_ERROR_MESSAGE: "Une erreur s'est produite lors de l'achat du panier",

  // Friends view
  DISPLAY_FRIENDS_LABEL: "Amis",

  // Friends Controller
  FILE_FRIEND_LOAD_FRIENDS_ERROR_MESSAGE: "Une erreur s'est produite lors de la recupération des amis",

  // News view
  DISPLAY_NEWS_LABEL: "News",
  DISPLAY_NEWS_SHOW_MORE: "Show More",
  DISPLAY_NEWS_COMMENT_SEND: "Send",

  // News Controller
  FILE_NEWS_LOAD_COMMENT_ERROR_MESSAGE: "Une erreur s'est produite lors de la recupération des commentaires",
  FILE_NEWS_SEND_COMMENT_ERROR_MESSAGE: "Une erreur s'est produite lors de la sauvegarde du commentaire",
  FILE_NEWS_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors de la recupération des actualités",
  FILE_NEWS_LOAD_ONE_NEWS_ERROR_MESSAGE: "La page que vous avez demandé n'existe pas",

  // Packs view
	DISPLAY_PACK_LABEL: "Packs du moment",
	DISPLAY_PACK_TIMELEFT: "Temps Restant",
	DISPLAY_PACK_AVERAGE: "Moyenne",
 	DISPLAY_PACK_YEAR_ALBUM: "Date de sortie",
	DISPLAY_PACK_ARTIST_NAME: "Artiste",
 	DISPLAY_PACK_DEV_NAME: "Soonzik",
 	DISPLAY_PACK_ASSOCIATION_NAME: "Association",
 	DISPLAY_PACK_BUY_PACK: "Acheter ce pack",
 	DISPLAY_PACK_TOTAL_PACK: "Total",
	DISPLAY_PACK_GIFT_LABEL: "Cadeau pour : ",
	DISPLAY_PACK_DEFINE_PRICE: "Definisez votre prix",

  // Packs Controller
  FILE_PACK_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors de la recupération des packs",
  FILE_PACK_LOAD_ONE_PACK_ERROR_MESSAGE: "La page que vous avez demandé n'est pas disponible",
  FILE_PACK_BUY_PACK_ERROR_MESSAGE: "Une erreur s'est produite lors de l'achat du pack",

  // Index view
  DISPLAY_INDEX_NEWS_SEE_MORE: "Voir plus de news",
  DISPLAY_INDEX_PACKS_SEE_MORE: "Voir plus de packs",
  DISPLAY_INDEX_BATTLES_SEE_MORE: "Voir plus de duels",
  DISPLAY_INDEX_SWEET_LABEL: "Sweets",
  DISPLAY_INDEX_ACTIVITY_LABEL: "Flux",
  DISPLAY_INDEX_INTERACTION_LABEL: "Interactions",
  DISPLAY_INDEX_NO_SWEET_LABEL: "Aucun sweet à afficher",
  DISPLAY_INDEX_ANSWER_LABEL: "Répondre",
  DISPLAY_INDEX_CHARACTER_LEFT_LABEL: "caractères restants",
  DISPLAY_INDEX_LAST_NEWS_LABEL: "Les dernieres news",
  DISPLAY_INDEX_LAST_PACKS_LABEL: "Les derniers packs",
  DISPLAY_INDEX_LAST_BATTLES_LABEL: "Les derniers duels",
  DISPLAY_INDEX_PAY_MORE_LABEL_PART_ONE: "Payez",
  DISPLAY_INDEX_PAY_MORE_LABEL_PART_TWO: "$ ou plus pour débloquer",
  DISPLAY_INDEX_SUGGESTION_LABEL: "Suggestions",
  DISPLAY_INDEX_BATTLE_PAGE_LABEL: "Accéder au duel",
  DISPLAY_INDEX_PACK_PAGE_LABEL: "Accéder au pack",

  // Index Controller
  FILE_INDEX_NEWS_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors du chargement des news",
  FILE_INDEX_PACKS_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors du chargement des packs",
  FILE_INDEX_BATTLES_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors du chargement des duels",
  FILE_INDEX_PROFILE_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors du chargement du profil de l'artiste",
  FILE_INDEX_FLUX_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors du chargement de votre flux",
  FILE_INDEX_SUGGESTION_LOAD_ERROR_MESSAGE: "Une erreur s'est produite lors du chargement des suggestions personnalisées",

  // Sign in View
  DISPLAY_SIGNIN_MAIL_PLACEHOLDER: "Adresse email",
  DISPLAY_SIGNIN_PASSWORD_PLACEHOLDER: "Mot de passe",
  DISPLAY_SIGNIN_REMEMBER_LABEL: "Se souvenir de moi",
  DISPLAY_SIGNIN_PASSWORD_FORGOTTEN_LABEL: "Mot de passe oublié ?",
  DISPLAY_SIGNIN_SIGNIN_LABEL: "Se connecter",
  DISPLAY_SIGNIN_NOT_SIGNUP_LABEL: "Pas encore inscrit ?",
  DISPLAY_SIGNIN_SIGNUP_LABEL: "S'inscrire",
  DISPLAY_SIGNIN_CONFIRM_NOT_RECEIVED_LABEL: "Confirmation de compte non reçus ?",
  DISPLAY_SIGNIN_SEND_LABEL: "Envoyer",
  DISPLAY_SIGNIN_NEWPASSWORD_LABEL: "Nouveau mot de passe",
  DISPLAY_SIGNIN_CONFIRM_NEWPASSWORD_LABEL: "Confirmez le nouveau mot de passe",

  // Commentaries view
  DISPLAY_COMMENTARY_TITLE_LABEL: "Commentaires",
  DISPLAY_NO_COMMENTARY_LABEL: "Aucun commentaires",

  // Application
  FILE_APP_PLAYLIST_NOT_FOUND_ERROR_MESSAGE: "Une erreur s'est produite pendant l'ajout à une liste de lecture : ",
  FILE_APP_LIKE_ERROR_MESSAGE: "Une erreur s'est produite lors de la mention 'J'aime'",
  FILE_APP_UNLIKE_ERROR_MESSAGE: "Une erreur s'est produite lors du retrait de la mention 'J'aime'",

  // Tooltip Controller
	FILE_TOOLTIP_ADD_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à l'ajout d'une musique dans une liste de lecture",
	FILE_TOOLTIP_SAVE_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à la sauvegarde d'une nouvelle liste de lecture",
	FILE_TOOLTIP_DELETE_PLAYLIST_ERROR_MESSAGE: "Une erreur s'est produite à la suppression de la liste de lecture : ",

  // Tooltip View
	DISPLAY_TOOLTIP_LISTEN_LABEL: "Ecouter",
	DISPLAY_TOOLTIP_ADD_CURRENT_PLAYLIST_LABEL: "Ajouter à la liste de lecture",
	DISPLAY_TOOLTIP_ADD_TO_PLAYLIST_LABEL: "Ajouter à une playlist",
	DISPLAY_TOOLTIP_REPLACE_PLAYLIST_LABEL: "Remplacer la liste de lecture courante",
	DISPLAY_TOOLTIP_CLOSE_LABEL: "Fermer",
	DISPLAY_TOOLTIP_BACK_LABEL: "Retour",
	DISPLAY_TOOLTIP_SHARE_LABEL: "Partager",
	DISPLAY_TOOLTIP_NEW_PLAYLIST_LABEL: "Nouvelle playlist",
	DISPLAY_TOOLTIP_NAME_LABEL: "Nom : ",
	DISPLAY_TOOLTIP_SAVE_BUTTON: "Sauvegarder",
	DISPLAY_TOOLTIP_SURE_DELETE_LABEL: "Êtes vous sûr ?",
	DISPLAY_TOOLTIP_YES_LABEL: "Oui",
	DISPLAY_TOOLTIP_NO_LABEL: "Non",

	// Feedback View
	DISPLAY_FEEDBACK_TITLE_LABEL: "Feedbacks",
	DISPLAY_FEEDBACK_EMAIL_LABEL: "Email",
	DISPLAY_FEEDBACK_TYPE_OBJ_LABEL: "Type de feedback",
	DISPLAY_FEEDBACK_OBJECT_LABEL: "Objet",
	DISPLAY_FEEDBACK_TEXT_LABEL: "Texte",
	DISPLAY_FEEDBACK_SAVE_LABEL: "Envoyer",
	DISPLAY_FEEDBACK_TYPE_OBJ_BUG_LABEL: "Bug sur le site",
	DISPLAY_FEEDBACK_TYPE_OBJ_PAYMENT_LABEL: "Problème de paiement",
	DISPLAY_FEEDBACK_TYPE_OBJ_ACCOUNT_LABEL: "Problème de compte",
	DISPLAY_FEEDBACK_TYPE_OBJ_OTHER_LABEL: "Autre",
	DISPLAY_FEEDBACK_SEND_MSG: "Le feedback a été envoyé. Merci de votre support.",
}
