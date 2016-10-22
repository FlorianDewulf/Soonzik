using Newtonsoft.Json.Linq;
using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.Networking.BackgroundTransfer;
using Windows.Storage;
using Windows.UI.Popups;

namespace SoonZik.ViewModels
{
    class MusicViewModel : INotifyPropertyChanged
    {
        string url = Singleton.Instance.url + "/musics/get/";

        public ObservableCollection<Music> musiclist { get; set; }

        // LIKE THAT CAUSE I DID NOT INSTANTIATE THEM IN LOAD_MUSIC i think ...
        private ObservableCollection<Comment> _commentlist;
        public ObservableCollection<Comment> commentlist
        {
            get { return _commentlist; }
            set
            {
                _commentlist = value;
                OnPropertyChanged("commentlist");
            }
        }

        private Music _music;
        public Music music
        {
            get { return _music; }
            set
            {
                _music = value;
                OnPropertyChanged("music");
            }
        }

        private string _comment_content;
        public string comment_content
        {
            get { return _comment_content; }
            set
            {
                _comment_content = value;
                OnPropertyChanged("comment_content");
            }
        }

        private int _user_note;
        public int user_note
        {
            get { return _user_note; }
            set
            {
                _user_note = value;
                OnPropertyChanged("user_note");
            }
        }

        private string _star_one;
        public string star_one
        {
            get { return _star_one; }
            set
            {
                _star_one = value;
                OnPropertyChanged("star_one");
            }
        }

        private string _star_two;
        public string star_two
        {
            get { return _star_two; }
            set
            {
                _star_two = value;
                OnPropertyChanged("star_two");
            }
        }

        private string _star_three;
        public string star_three
        {
            get { return _star_three; }
            set
            {
                _star_three = value;
                OnPropertyChanged("star_three");
            }
        }

        private string _star_four;
        public string star_four
        {
            get { return _star_four; }
            set
            {
                _star_four = value;
                OnPropertyChanged("star_four");
            }
        }

        private string _star_five;
        public string star_five
        {
            get { return _star_five; }
            set
            {
                _star_five = value;
                OnPropertyChanged("star_five");
            }
        }

        public ICommand do_send_comment
        {
            get;
            private set;
        }

        public ICommand do_add_to_cart
        {
            get;
            private set;
        }

        public ICommand do_dl_music
        {
            get;
            private set;
        }

        public ICommand do_note_one
        {
            get;
            private set;
        }
        public ICommand do_note_two
        {
            get;
            private set;
        }
        public ICommand do_note_three
        {
            get;
            private set;
        }
        public ICommand do_note_four
        {
            get;
            private set;
        }
        public ICommand do_note_five
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

        public MusicViewModel(int id)
        {
            do_send_comment = new RelayCommand(send_comment);
            do_add_to_cart = new RelayCommand(add_to_cart);
            do_dl_music = new RelayCommand(dl_music);
            do_note_one = new RelayCommand(note_one);
            do_note_two = new RelayCommand(note_two);
            do_note_three = new RelayCommand(note_three);
            do_note_four = new RelayCommand(note_four);
            do_note_five = new RelayCommand(note_five);

            load_music(id);
        }

        public MusicViewModel()
        {
            load_musics();
        }

        async void load_music(int id)
        {
            Exception exception = null;

            try
            {
                // Load the news
                music = await Http_get.get_music_by_id(id);

                var comment_vm = await CommentViewModel.load_comments("/musics/" + music.id.ToString());
                commentlist = comment_vm;

                var note = (List<Note>) await Http_get.get_object(new List<Note>(), "/musics/getNotes?user_id=" + Singleton.Instance.Current_user.id.ToString() + "&arr_id=[" + music.id.ToString() + "]");

                if (note.Any())
                    user_note = note[0].note;
                else
                    user_note = 0;

                set_stars(user_note);
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de la musique").ShowAsync();
        }

        async public void send_comment()
        {
            if (await CommentViewModel.send_comment(comment_content, "musics", music.id.ToString()))
            {
                // New comment to add in the observable collection in order to refresh the list ...
                var new_comment = new Comment();
                new_comment.user = Singleton.Instance.Current_user;
                new_comment.content = comment_content;
                commentlist.Insert(0, new_comment);
                // To delete text in comment bar
                comment_content = "";
            }
        }

        async void load_musics()
        {
            Exception exception = null;
            musiclist = new ObservableCollection<Music>();

            try
            {
                var musics = (List<Music>)await Http_get.get_object(new List<Music>(), "musics");

                foreach (var item in musics)
                    musiclist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des musiques").ShowAsync();
        }

        public void add_to_cart()
        {
            //                        USER ID,                            ALBUM ID,   TYPE,  GIFT USER ID (IF < 0 : NOT A GIFT)
            CartViewModel.add_to_cart(Singleton.Instance.Current_user.id, music.id, "Music", 0);
        }

        async public void set_note(int note)
        {
            Exception exception = null;
            var request = new Http_post();

            try
            {
                string url = "/musics/" + music.id.ToString() + "/note/" + note.ToString();
                string data =
                    "user_id=" + Singleton.Instance.Current_user.id +
                    "&secureKey=" + await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());


                // HTTP_POST -> URL + DATA
                var response = await request.post_request(url, data);
                var json = JObject.Parse(response).SelectToken("message");

                //if (json.ToString() == "Created")
                //    await new MessageDialog("note OK").ShowAsync();
                //else
                //    await new MessageDialog("note KO").ShowAsync();

            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog(exception.Message, "Erreur lors de la notation de la musique").ShowAsync();
        }

        public void note_one()
        {
            set_note(1);
            set_stars(1);
        }
        public void note_two()
        {
            set_note(2);
            set_stars(2);
        }
        public void note_three()
        {
            set_note(3);
            set_stars(3);
        }
        public void note_four()
        {
            set_note(4);
            set_stars(4);
        }
        public void note_five()
        {
            set_note(5);
            set_stars(5);
        }

        public void set_stars(int user_note)
        {
            if (user_note == 0)
            {
                star_one = "ms-appx:///Assets/g_star.png";
                star_two = "ms-appx:///Assets/g_star.png";
                star_three = "ms-appx:///Assets/g_star.png";
                star_four = "ms-appx:///Assets/g_star.png";
                star_five = "ms-appx:///Assets/g_star.png";
            }
            if (user_note == 1)
            {
                star_one = "ms-appx:///Assets/y_star.png";
                star_two = "ms-appx:///Assets/g_star.png";
                star_three = "ms-appx:///Assets/g_star.png";
                star_four = "ms-appx:///Assets/g_star.png";
                star_five = "ms-appx:///Assets/g_star.png";
            }

            if (user_note == 2)
            {
                star_one = "ms-appx:///Assets/o_star.png";
                star_two = "ms-appx:///Assets/y_star.png";
                star_three = "ms-appx:///Assets/g_star.png";
                star_four = "ms-appx:///Assets/g_star.png";
                star_five = "ms-appx:///Assets/g_star.png";
            }
            if (user_note == 3)
            {
                star_one = "ms-appx:///Assets/o_star.png";
                star_two = "ms-appx:///Assets/o_star.png";
                star_three = "ms-appx:///Assets/y_star.png";
                star_four = "ms-appx:///Assets/g_star.png";
                star_five = "ms-appx:///Assets/g_star.png";
            }
            if (user_note == 4)
            {
                star_one = "ms-appx:///Assets/o_star.png";
                star_two = "ms-appx:///Assets/o_star.png";
                star_three = "ms-appx:///Assets/o_star.png";
                star_four = "ms-appx:///Assets/y_star.png";
                star_five = "ms-appx:///Assets/g_star.png";
            }
            if (user_note == 5)
            {
                star_one = "ms-appx:///Assets/o_star.png";
                star_two = "ms-appx:///Assets/o_star.png";
                star_three = "ms-appx:///Assets/o_star.png";
                star_four = "ms-appx:///Assets/o_star.png";
                star_five = "ms-appx:///Assets/y_star.png";
            }
        }

        public async void dl_music()
        {
            try
            {
                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());
                string uri = url + music.id.ToString() + "?download=true&user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + secureKey;
                Uri source;

                if (!Uri.TryCreate(uri.Trim(), UriKind.Absolute, out source))
                {
                    return;
                }

                // FILE NAME
                string destination = music.user.username + " - " + music.title + ".mp3";

                StorageFile destinationFile;
                destinationFile = await KnownFolders.MusicLibrary.CreateFileAsync(destination, CreationCollisionOption.GenerateUniqueName);
                BackgroundDownloader downloader = new BackgroundDownloader();
                DownloadOperation download = downloader.CreateDownload(source, destinationFile);

                await download.StartAsync();
                await new MessageDialog("Le téléchargement de la musique est complet").ShowAsync();

            }
            catch (FileNotFoundException ex)
            {
                new MessageDialog("Erreur lors du telechargement de la musique").ShowAsync();
                return;
            }
        }
    }
}
