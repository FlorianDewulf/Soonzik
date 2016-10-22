using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml.Media.Imaging;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.Utils;
using SoonZik.Views;
using News = SoonZik.HttpRequest.Poco.News;

namespace SoonZik.ViewModel
{
    public class NewsViewModel : ViewModelBase
    {
        #region Ctor

        public NewsViewModel()
        {
            _listNews = new ObservableCollection<News>();
            Charge();
            ItemClickCommand = new RelayCommand(ItemClickExecute);
        }

        #endregion

        #region Attribute

        private const string UrlImage = "http://soonzikapi.herokuapp.com/assets/news/";
        public static MessagePrompt MessagePrompt { get; set; }

        public ObservableCollection<News> ListNews
        {
            get { return _listNews; }
            set
            {
                _listNews = value;
                RaisePropertyChanged("ListNews");
            }
        }

        private ObservableCollection<News> _listNews;

        private News _selectedNews;

        public static News DetailSelectedNews { get; set; }

        public News SelectedNews
        {
            get { return _selectedNews; }
            set
            {
                _selectedNews = value;
                RaisePropertyChanged("SelectedNews");
            }
        }

        private RelayCommand _itemClickCommand;

        public RelayCommand ItemClickCommand
        {
            get { return _itemClickCommand; }
            set
            {
                _itemClickCommand = value;
                RaisePropertyChanged("ItemClickCommand");
            }
        }

        #endregion

        #region Method

        private void ItemClickExecute()
        {
            var get = new HttpRequestGet();
            ValidateKey.GetValideKey();
            var res = get.GetSecureNews(new News(), "news", SelectedNews.id.ToString(),
                Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser);
            res.ContinueWith(delegate(Task<object> tmp)
            {
                var news = tmp.Result as News;
                if (news != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            news.imageNews =
                                new BitmapImage(new Uri(UrlImage + news.attachments[0].url, UriKind.RelativeOrAbsolute));
                            NewsDetailViewModel.TheNews = news;
                            GlobalMenuControl.SetChildren(new NewsDetail());
                        });
                }
            });
        }

        public void Charge()
        {
            var request = new HttpRequestGet();

            var listNews = request.GetListNews(new List<News>(), "news", Singleton.Singleton.Instance().CurrentUser.language);
            listNews.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<News>;
                if (test != null)
                {
                    foreach (var item in test)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () =>
                            {
                                item.attachments[0].url =
                                    new Uri(UrlImage + item.attachments[0].url, UriKind.RelativeOrAbsolute).ToString();
                                ListNews.Add(item);
                            });
                    }
                }
            });
        }

        #endregion
    }
}