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
using Windows.Data.Xml.Dom;
using Windows.Networking.BackgroundTransfer;
using Windows.Storage;
using Windows.UI.Notifications;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Media.Imaging;

namespace SoonZik.ViewModels
{
    class AlbumViewModel : INotifyPropertyChanged
    {
        string url = Singleton.Instance.url + "/musics/get/";

        public ObservableCollection<Album> albumlist { get; set; }

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

        private Album _album;
        public Album album
        {
            get { return _album; }
            set
            {
                _album = value;
                OnPropertyChanged("album");
            }
        }

        private BitmapImage _alb_img;
        public BitmapImage alb_img
        {
            get { return _alb_img; }
            set
            {
                _alb_img = value;
                OnPropertyChanged("alb_img");
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

        public ICommand do_dl_album
        {
            get;
            private set;
        }


        public ICommand do_like
        {
            get;
            private set;
        }
        public ICommand do_unlike
        {
            get;
            private set;
        }

        private Visibility _like_btn;
        public Visibility like_btn
        {
            get { return _like_btn; }
            set
            {
                _like_btn = value;
                OnPropertyChanged("like_btn");
            }
        }

        private Visibility _unlike_btn;
        public Visibility unlike_btn
        {
            get { return _unlike_btn; }
            set
            {
                _unlike_btn = value;
                OnPropertyChanged("unlike_btn");
            }
        }

        private int _likes;
        public int likes
        {
            get { return _likes; }
            set
            {
                _likes = value;
                OnPropertyChanged("likes");
            }
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

        public AlbumViewModel()
        {
            load_albums();
        }

        public AlbumViewModel(int id)
        {
            //commentlist = new ObservableCollection<Comment>();
            do_send_comment = new RelayCommand(send_comment);
            do_add_to_cart = new RelayCommand(add_to_cart);
            do_like = new RelayCommand(like);
            do_unlike = new RelayCommand(unlike);
            do_dl_album = new RelayCommand(dl_album);
            like_btn = Visibility.Collapsed;
            unlike_btn = Visibility.Collapsed;
            load_album(id);
        }

        async void load_album(int id)
        {
            Exception exception = null;

            try
            {
                // Load the news
                album = await Http_get.get_album_by_id(id);

                if (album.hasLiked)
                    unlike_btn = Visibility.Visible;
                else
                    like_btn = Visibility.Visible;


                alb_img = new BitmapImage(new Uri(Singleton.Instance.url + "/assets/albums/" + album.image, UriKind.RelativeOrAbsolute));


                likes = album.likes;

                var comment_vm = await CommentViewModel.load_comments("/albums/" + album.id.ToString());
                commentlist = comment_vm;
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de l'album").ShowAsync();
        }

        async void load_albums()
        {
            Exception exception = null;
            albumlist = new ObservableCollection<Album>();

            try
            {
                var albums = (List<Album>)await Http_get.get_object(new List<Album>(), "albums");
                foreach (var item in albums)
                    albumlist.Add(item);
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des albums").ShowAsync();
        }

        async public void send_comment()
        {
            if (await CommentViewModel.send_comment(comment_content, "albums", album.id.ToString()))
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

        async public void like()
        {
            if (await LikeViewModel.like("Albums", album.id.ToString()))
            {
                like_btn = Visibility.Collapsed;
                unlike_btn = Visibility.Visible;
                likes += 1;
            }
        }

        async public void unlike()
        {
            if (await LikeViewModel.unlike("Albums", album.id.ToString()))
            {
                like_btn = Visibility.Visible;
                unlike_btn = Visibility.Collapsed;
                likes -= 1;
            }
        }

        public void add_to_cart()
        {
            //                        USER ID,                            ALBUM ID,   TYPE,  GIFT USER ID (IF < 0 : NOT A GIFT)
            CartViewModel.add_to_cart(Singleton.Instance.Current_user.id, album.id, "Album", 0);
        }

        public async void dl_musics_album(StorageFolder destinationFolder, int music_id, string title)
        {
 
            // PATH NAME

            try
            {

                string secureKey = await Security.getSecureKey(Singleton.Instance.Current_user.id.ToString());
                string uri = url + music_id.ToString() + "?download=true&user_id=" + Singleton.Instance.Current_user.id.ToString() + "&secureKey=" + secureKey;

                Uri source;
                if (!Uri.TryCreate(uri.Trim(), UriKind.Absolute, out source))
                {
                    return;
                }

                // FILE NAME
                string file_name = album.user.username + " - " + title + ".mp3"; // file_name


                StorageFile destinationFile = await destinationFolder.CreateFileAsync(file_name, CreationCollisionOption.GenerateUniqueName);

                BackgroundDownloader downloader = new BackgroundDownloader();
                DownloadOperation download = downloader.CreateDownload(source, destinationFile);

                await download.StartAsync();
                //download.GetResponseInformation
                //await new MessageDialog("Le téléchargement est complet").ShowAsync();

            }
            catch (FileNotFoundException ex)
            {
                return;
            }
        }


        //public async void dl_musics_album(StorageFolder destinationFolder, Music music)
        //{
        //    string url = "http://api.lvh.me:3000/musics/get/" + music.id.ToString() + "?download=true";
        //    Uri source;

        //    if (!Uri.TryCreate(url.Trim(), UriKind.Absolute, out source))
        //    {
        //        return;
        //    }

        //    // FILE NAME
        //    string file_name = music.user.username + " - " + music.title + ".mp3"; // file_name

        //    // PATH NAME
        //    StorageFile destinationFile;

        //    try
        //    {
        //        destinationFile = await destinationFolder.CreateFileAsync(file_name, CreationCollisionOption.GenerateUniqueName);

        //        BackgroundDownloader downloader = new BackgroundDownloader();
        //        DownloadOperation download = downloader.CreateDownload(source, destinationFile);

        //        await download.StartAsync();
        //        await new MessageDialog("Le téléchargement est complet").ShowAsync();

        //    }
        //    catch (FileNotFoundException ex)
        //    {
        //        new MessageDialog("Erreur lors du telechargement de la musique").ShowAsync();
        //        return;
        //    }
        //}

        public async void dl_album()
        {
            try
            {
                string dir_name = album.user.username + " - " + album.title;

                StorageFolder destinationFolder;
                destinationFolder = await KnownFolders.MusicLibrary.CreateFolderAsync(dir_name, CreationCollisionOption.GenerateUniqueName);

                foreach (var music in album.musics)
                {
                    dl_musics_album(destinationFolder, music.id, music.title);
                    //dl_musics_album(destinationFolder, music);
                }

                await new MessageDialog("Le téléchargement de l'album est complet").ShowAsync();

            }
            catch (Exception e)
            {
                new MessageDialog("Erreur lors de la récupération de l'album").ShowAsync();
            }

        }
    }
}
