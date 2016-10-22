using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.System.UserProfile;
using Windows.UI.Core;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls.Primitives;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class NewsDetailViewModel : ViewModelBase
    {
        #region Ctor

        public NewsDetailViewModel()
        {
            SendComment = new RelayCommand(SendCommentExecute);
            LikeCommand = new RelayCommand(LikeCommandExecute);
            SelectionCommand = new RelayCommand(SelectionCommandExecute);
            ShareTapped = new RelayCommand(ShareTappedExecute);
        }

        #endregion

        #region Attribute

        private string _likes;

        public string Likes
        {
            get { return _likes; }
            set
            {
                _likes = value;
                RaisePropertyChanged("Likes");
            }
        }

        public static News TheNews { get; set; }
        private bool share;
        public static Popup SharePopup { get; set; }

        public ICommand ShareTapped { get; set; }
        private string _crypto { get; set; }
        private BitmapImage _like;

        private readonly BitmapImage bmLike =
            new BitmapImage(new Uri("ms-appx:///Resources/Icones/like_icon.png", UriKind.RelativeOrAbsolute));

        private readonly BitmapImage bmDislike =
            new BitmapImage(new Uri("ms-appx:///Resources/Icones/notlike_icon.png", UriKind.RelativeOrAbsolute));

        public BitmapImage Like
        {
            get { return _like; }
            set
            {
                _like = value;
                RaisePropertyChanged("Like");
            }
        }

        public ICommand LikeCommand { get; private set; }
        public ICommand SendComment { get; private set; }
        public ICommand SelectionCommand { get; private set; }
        private ObservableCollection<Comments> _listCommNews;

        public ObservableCollection<Comments> ListCommNews
        {
            get { return _listCommNews; }
            set
            {
                _listCommNews = value;
                RaisePropertyChanged("ListCommNews");
            }
        }

        public News SelectNews { get; set; }
        private string _newsContent;

        public string NewsContent
        {
            get { return _newsContent; }
            set
            {
                _newsContent = value;
                RaisePropertyChanged("NewsContent");
            }
        }

        private string _newsTitle;

        public string NewsTitle
        {
            get { return _newsTitle; }
            set
            {
                _newsTitle = value;
                RaisePropertyChanged("NewsTitle");
            }
        }

        private string _textComment;

        public string TextComment
        {
            get { return _textComment; }
            set
            {
                _textComment = value;
                RaisePropertyChanged("TextComment");
            }
        }

        #endregion

        #region Method

        private void SelectionCommandExecute()
        {
            SelectNews = TheNews;
            Like = SelectNews.hasLiked ? bmLike : bmDislike;
            Likes = SelectNews.likes;
            var ci = new CultureInfo(GlobalizationPreferences.Languages[0]);
            if (ci.Name.Equals("en-US"))
            {
                NewsContent = SelectNews.content;
                NewsTitle = SelectNews.title;
            }
            else if (ci.Name.Equals("fr-FR"))
            {
                NewsContent = SelectNews.content;
                NewsTitle = SelectNews.title;
            }
            LoadComment();
        }

        private void LikeCommandExecute()
        {
            if (!SelectNews.hasLiked)
            {
                Like = bmLike;
                ValidateKey.GetValideKey();
                var post = new HttpRequestPost();
                var res = post.SetLike("News", Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString(), SelectNews.id.ToString());
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var result = tmp2.Result;
                    if (result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            UpadteNews);
                    }
                });
            }
            else
            {
                Like = bmDislike;
                ValidateKey.GetValideKey();
                var get = new HttpRequestGet();
                var res = get.DestroyLike("News", SelectNews.id.ToString(), Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString());
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var result = tmp2;
                    if (result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            UpadteNews);
                    }
                });
            }
        }

        private void UpadteNews()
        {
            var request = new HttpRequestGet();
            ValidateKey.CheckValidateKey();
            var news = request.GetSecureObject(new News(), "news", SelectNews.id.ToString(),
                Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            news.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as News;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            SelectNews.hasLiked = test.hasLiked;
                            SelectNews.likes = test.likes;
                            Likes = test.likes;
                        });
                }
            });
        }

        private void LoadComment()
        {
            TextComment = "";
            var request = new HttpRequestGet();
            ListCommNews = new ObservableCollection<Comments>();
            var elem = "news/" + SelectNews.id + "/comments";
            var listCom = request.GetListObject(new List<Comments>(), elem);
            listCom.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Comments>;
                if (res != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal, () =>
                    {
                        foreach (var item in res)
                        {
                            ListCommNews.Add(item);
                        }
                    });
                }
            });
        }

        private void SendCommentExecute()
        {
            var post = new HttpRequestPost();
            try
            {
                ValidateKey.GetValideKey();
                var test = post.SendComment(TextComment, null, SelectNews, Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser);
                test.ContinueWith(delegate(Task<string> tmp)
                {
                    var res = tmp.Result;
                    if (res != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            LoadComment);
                    }
                });
            }
            catch (Exception)
            {
                var loader = new ResourceLoader();
                new MessageDialog(loader.GetString("ErrorTweet")).ShowAsync();
            }
        }

        private void ShareTappedExecute()
        {
            share = true;
            SharePopup = new Popup();
            var content = new NewsSharePopup(SelectNews);
            var width = content.Width;
            var height = content.Height;
            SharePopup.Child = content;
            SharePopup.VerticalOffset = (Window.Current.Bounds.Height - height)/2;
            SharePopup.HorizontalOffset = (Window.Current.Bounds.Width - width)/2;
            SharePopup.IsOpen = true;
            SharePopup.Closed += SharePopupOnClosed;
        }

        private void SharePopupOnClosed(object sender, object e)
        {
            SharePopup.IsOpen = false;
        }

        #endregion
    }
}