using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class PlayerViewModel : INotifyPropertyChanged
    {
        // PLAYER

        private Uri _uri;
        public Uri uri
        {
            get { return _uri; }
            set
            {
                _uri = value;
                OnPropertyChanged("uri");
            }
        }

        private Music _selected_music_in_player_playlist;
        public Music selected_music_in_player_playlist
        {
            get { return _selected_music_in_player_playlist; }
            set
            {
                _selected_music_in_player_playlist = value;
                Singleton.Instance.selected_music = value;
                OnPropertyChanged("selected_music_in_player_playlist");
            }
        }

        
        // PLAYLIST

        public ObservableCollection<Playlist> playlist_list { get; set; }
        public ObservableCollection<Music> playlist_update_music { get; set; }

        private Playlist _selected_playlit;
        public Playlist selected_playlist
        {
            get { return _selected_playlit; }
            set
            {
                _selected_playlit = value;
                OnPropertyChanged("selected_playlist");
            }
        }

        private Album _selected_album;
        public Album selected_album
        {
            get { return _selected_album; }
            set
            {
                _selected_album = value;
                OnPropertyChanged("selected_album");
            }
        }

        private Music _selected_music;
        public Music selected_music
        {
            get { return _selected_music; }
            set
            {
                _selected_music = value;
                OnPropertyChanged("selected_music");
            }
        }

        private Music _selected_music_in_playlist;
        public Music selected_music_playlist
        {
            get { return _selected_music_in_playlist; }
            set
            {
                _selected_music_in_playlist = value;
                OnPropertyChanged("selected_music_playlist");
            }
        }

        private MusicOwnByUser _music_own;
        public MusicOwnByUser music_own
        {
            get { return _music_own; }
            set
            {
                _music_own = value;
                OnPropertyChanged("music_own");
            }
        }

        private List<Music> _music_list_to_add;
        public List<Music> music_list_to_add
        {
            get { return _music_list_to_add; }
            set
            {
                _music_list_to_add = value;
                OnPropertyChanged("music_list_to_add");
            }
        }

        private List<Music> _music_list_to_update;
        public List<Music> music_list_to_update
        {
            get { return _music_list_to_update; }
            set
            {
                _music_list_to_update = value;
                OnPropertyChanged("music_list_to_update");
            }
        }

        private string _playlist_name;
        public string playlist_name
        {
            get { return _playlist_name; }
            set
            {
                _playlist_name = value;
                OnPropertyChanged("playlist_name");
            }
        }

        public ICommand do_create_playlist
        {
            get;
            private set;
        }

        public ICommand do_delete_playlist
        {
            get;
            private set;
        }

        public ICommand do_add_to_playlist
        {
            get;
            private set;
        }
        public ICommand do_add_to_update_playlist
        {
            get;
            private set;
        }

        public ICommand do_remove_to_playlist
        {
            get;
            private set;
        }

        public ICommand do_update_playlist
        {
            get;
            private set;
        }
        public ICommand do_cancel
        {
            get;
            private set;
        }
        public ICommand do_init_update
        {
            get;
            private set;
        }
        public ICommand do_init_create
        {
            get;
            private set;
        }



        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }


        public PlayerViewModel()
        {
            music_list_to_add = new List<Music>();
            music_list_to_update = new List<Music>();

            playlist_list = new ObservableCollection<Playlist>();
            playlist_update_music = new ObservableCollection<Music>();

            load_music_own();
            load_playlist();


            // PLAYLIST
            do_create_playlist = new RelayCommand(create_playlist);
            do_delete_playlist = new RelayCommand(delete_playlist);
            do_add_to_playlist = new RelayCommand(add_to_playlist);
            do_init_update = new RelayCommand(init_update);
            do_cancel = new RelayCommand(cancel);
            do_update_playlist = new RelayCommand(update_playlist);
            do_add_to_update_playlist = new RelayCommand(add_to_update_playlist);
            do_remove_to_playlist = new RelayCommand(remove_to_playlist);
        }

        void init_player()
        {
            if (playlist_list.Any())
                if (playlist_list[0].musics.Any())
                    uri = new Uri("http://api.lvh.me:3000/musics/get/" + playlist_list[0].musics[0].id.ToString(), UriKind.RelativeOrAbsolute);
        }

        async void load_music_own()
        {
            Exception exception = null;
            music_own = new MusicOwnByUser();

            try
            {
                music_own = (MusicOwnByUser)await Http_get.get_object(new MusicOwnByUser(), "/users/getmusics?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()));
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la récupération de la musique de l'utilisateur").ShowAsync();
        }

        async void load_playlist()
        {
            Exception exception = null;
            // ici new observable avant
            try
            {
                var playlists = (List<Playlist>)await Http_get.get_object(new List<Playlist>(), "/playlists/find?attribute[user_id]=" + Singleton.Instance.Current_user.id.ToString());


                foreach (var item in playlists)
                    playlist_list.Add(item);

                //init_player();

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la récupération des playlists de l'utilisateur").ShowAsync();
        }

        async void create_playlist()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                if (playlist_name == null || playlist_name == "")
                {
                    await new MessageDialog("Entrez un nom de playlist").ShowAsync();
                    return;
                }
                if (playlist_name.Length < 4)
                {
                    await new MessageDialog("Le nom de la playlist est trop court").ShowAsync();
                    return;
                }

                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&playlist[user_id]=" + Singleton.Instance.Current_user.id.ToString() +
                    "&playlist[name]=" + playlist_name;

                var response = await request.post_request("/playlists/save", data);

                // to get the id of the new playlist
                dynamic json = JObject.Parse(response).SelectToken("content");

                // get ids
                string musics_id = "";
                //foreach (var music in music_list_to_add)
                //    musics_id += music.id.ToString() + ",";

                foreach (var music in playlist_update_music)
                    musics_id += music.id.ToString() + ",";

                var data_update =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&id=" + json.id +
                    "&playlist[user_id]=" + Singleton.Instance.Current_user.id.ToString() +
                    "&playlist[name]=" + playlist_name +
                    "&playlist[music]=[" + musics_id.Remove(musics_id.Length - 1) + "]";

                var response_update = await request.post_request("/playlists/update", data_update);

                var jsonbis = JObject.Parse(response_update).SelectToken("message");

                if (jsonbis.ToString() == "Created")
                    await new MessageDialog("Playlist créée avec succès").ShowAsync();
                else
                    await new MessageDialog("Erreur lors de la création de la playlist").ShowAsync();


                // clean music list & name
                music_list_to_add.Clear();
                playlist_name = "";

                // reload playlist list
                playlist_update_music.Clear();
                playlist_list.Clear();
                load_playlist();

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la création de la playlist").ShowAsync();

        }

        void add_to_playlist()
        {
            if (selected_music != null)
                _music_list_to_add.Add(selected_music);
        }

        async void delete_playlist()
        {
            Exception exception = null;
            var request = new Http_get();

            try
            {
                //var response = await request.g("/playlists/destroy", data);
                var ret = await Http_get.get_data("/playlists/destroy?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString()) + "&id=" + selected_playlist.id.ToString());

                // reload playlist list
                playlist_list.Clear();
                load_playlist();

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la création de la playlist").ShowAsync();
        }

        async void init_update()
        {
            playlist_update_music.Clear();

            //playlist_update_music = new ObservableCollection<Music>(selected_playlist.musics);
            if (selected_playlist != null)
                foreach (var music in selected_playlist.musics)
                    playlist_update_music.Add(music);
            else
                await new MessageDialog("Vous devez selectionez une playlist").ShowAsync();


        }

        async void update_playlist()
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());

                string musics_id = "";
                foreach (var music in playlist_update_music)
                    musics_id += music.id.ToString() + ",";


                var data_update =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + secureKey +
                    "&id=" + selected_playlist.id +
                    "&playlist[user_id]=" + Singleton.Instance.Current_user.id.ToString() +
                    "&playlist[name]=" + WebUtility.UrlEncode(selected_playlist.name) +
                    "&playlist[music]=[" + musics_id.Remove(musics_id.Length - 1) + "]";

                var response_update = await request.post_request("/playlists/update", data_update);

                var jsonbis = JObject.Parse(response_update).SelectToken("message");

                if (jsonbis.ToString() == "Created")
                    await new MessageDialog("Playlist mise à jour").ShowAsync();
                else
                    await new MessageDialog("Erreur lors de la mise à jour de la playlist").ShowAsync();


                // clear value & list
                music_list_to_add.Clear();
                playlist_name = "";
                playlist_list.Clear();
                playlist_update_music.Clear();
                load_playlist();
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la mise à jour de la playlist").ShowAsync();

        }

        void add_to_update_playlist()
        {
            //if (selected_music != null)
            //    selected_playlist.musics.Add(selected_music);

            if (selected_music != null)
                playlist_update_music.Add(selected_music);
        }

        void remove_to_playlist()
        {

            if (selected_music_playlist != null)
                playlist_update_music.Remove(selected_music_playlist);

            //if (selected_music != null)
            //    selected_playlist.musics.Remove(selected_music_playlist);
        }

        void cancel()
        {
            playlist_update_music.Clear();
            playlist_name = null;
        }
    }
}
