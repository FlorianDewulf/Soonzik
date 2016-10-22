using System;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;
using Windows.UI.Xaml.Media.Imaging;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.Helpers;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class ConcertDetailViewModel : ViewModelBase
    {
        #region Ctor

        public ConcertDetailViewModel()
        {
            LoadedCommand = new RelayCommand(LoadedExecute);
            LikeCommand = new RelayCommand(LikeCommandExecute);
        }

        #endregion

        #region Attribute

        private string _theAddress;

        public string TheAddress
        {
            get { return _theAddress;}
            set
            {
                _theAddress = value;
                RaisePropertyChanged("TheAddress");
            }
        }

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
        public static Concerts Concert;
        private Concerts _theConcert;

        public Concerts TheConcert
        {
            get { return _theConcert; }
            set
            {
                _theConcert = value;
                RaisePropertyChanged("TheConcert");
            }
        }
        public ICommand LoadedCommand { get; private set; }
        public ICommand LikeCommand { get; private set; }
        #endregion

        #region Method

        private void LoadedExecute()
        {
            TheConcert = Concert;
            Like = TheConcert.hasLiked ? bmLike : bmDislike;
            Likes = TheConcert.likes;
            TheConcert.user.profilImage = new BitmapImage(new Uri(Constant.UrlImageUser + TheConcert.user.image, UriKind.RelativeOrAbsolute));
            TheAddress = TheConcert.address.NumberStreet + " " + TheConcert.address.Street + " " +
                         TheConcert.address.Complement + "\n" +
                         TheConcert.address.Zipcode + " " + TheConcert.address.City + " " + TheConcert.address.Country;
        }

        private void LikeCommandExecute()
        {
            if (!TheConcert.hasLiked)
            {
                Like = bmLike;
                ValidateKey.GetValideKey();
                var post = new HttpRequestPost();
                var res = post.SetLike("Concerts", Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString(), TheConcert.id.ToString());
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var result = tmp2.Result;
                    if (result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            UpdateConcert);
                    }
                });
            }
            else
            {
                Like = bmDislike;
                ValidateKey.GetValideKey();
                var get = new HttpRequestGet();
                var res = get.DestroyLike("Concerts", TheConcert.id.ToString(), Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString());
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var result = tmp2;
                    if (result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            UpdateConcert);
                    }
                });
            }
        }

        private void UpdateConcert()
        {
            var request = new HttpRequestGet();
            ValidateKey.CheckValidateKey();
            var news = request.GetSecureObject(new Concerts(), "concerts", TheConcert.id.ToString(),
                Singleton.Singleton.Instance().SecureKey, Singleton.Singleton.Instance().CurrentUser.id.ToString());
            news.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as Concerts;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            TheConcert.hasLiked = test.hasLiked;
                            TheConcert.likes = test.likes;
                            Likes = test.likes;
                        });
                }
            });
        }
        #endregion
    }
}
