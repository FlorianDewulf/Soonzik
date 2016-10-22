using SoonZik.Common;
using SoonZik.Models;
using SoonZik.Tools;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Media.Imaging;

namespace SoonZik.ViewModels
{
    class NewsViewModel : INotifyPropertyChanged
    {
        public ObservableCollection<News> newslist { get; set; }

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

        private News _news;
        public News news
        {
            get { return _news; }
            set
            {
                _news = value;
                OnPropertyChanged("news");
            }
        }

        private BitmapImage _news_img;
        public BitmapImage news_img
        {
            get { return _news_img; }
            set
            {
                _news_img = value;
                OnPropertyChanged("news_img");
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

        //private string _content;
        //public string content
        //{
        //    get { return _content; }
        //    set
        //    {
        //        _content = value;
        //        OnPropertyChanged("content");
        //    }
        //}

        public ICommand do_send_comment
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

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string name)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(name));
            }
        }

        // CLICK SUR UNE NEWS CTOR
        public NewsViewModel(int id)
        {
            commentlist = new ObservableCollection<Comment>();
            do_send_comment = new RelayCommand(send_comment);
            do_like = new RelayCommand(like);
            do_unlike = new RelayCommand(unlike);
            like_btn = Visibility.Collapsed;
            unlike_btn = Visibility.Collapsed;
            load_news(id);
        }

        // CTOR POUR LA PAGE LISTE NEWS
        public NewsViewModel()
        {
            load_news_list();
        }

        async public void send_comment()
        {
            if (await CommentViewModel.send_comment(comment_content, "news", news.id.ToString()))
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
            if (await LikeViewModel.like("News", news.id.ToString()))
            {
                like_btn = Visibility.Collapsed;
                unlike_btn = Visibility.Visible;
                likes += 1;
            }
        }

        async public void unlike()
        {
            if (await LikeViewModel.unlike("News", news.id.ToString()))
            {
                like_btn = Visibility.Visible;
                unlike_btn = Visibility.Collapsed;
                likes -= 1;
            }
        }

        async public void load_news(int id)
        {
            Exception exception = null;

            try
            {
                if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                    news = await Http_get.get_news_by_id_and_language(id, "FR");
                else
                    news = await Http_get.get_news_by_id_and_language(id, "EN");

                if (news.hasLiked)
                    unlike_btn = Visibility.Visible;
                else
                    like_btn = Visibility.Visible;

                likes = news.likes;

                if (news.attachments.Any())
                {
                    news_img = new BitmapImage(new Uri(Singleton.Instance.url + "/assets/news/" + news.attachments[0].url, UriKind.RelativeOrAbsolute));
                }

                var comment_vm = await CommentViewModel.load_comments("/news/" + news.id.ToString());
                commentlist = comment_vm;
            }

            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération de la news").ShowAsync();
        }

        async void load_news_list()
        {
            Exception exception = null;
            newslist = new ObservableCollection<News>();

            try
            {
                List<News> news;

                if (Windows.System.UserProfile.GlobalizationPreferences.Languages[0] == "fr-FR")
                    news = (List<News>)await Http_get.get_object(new List<News>(), "news?language=FR");
                else
                    news = (List<News>)await Http_get.get_object(new List<News>(), "news?language=EN");

                foreach (var item in news)
                {
                    if (item.attachments.Any())
                        item.image = Singleton.Instance.url + "/assets/news/" + item.attachments[0].url;
                    newslist.Add(item);

                }
            }
            catch (Exception e)
            {
                exception = e;
            }

            if (exception != null)
                await new MessageDialog("Erreur lors de la récupération des news").ShowAsync();
        }
    }
}
