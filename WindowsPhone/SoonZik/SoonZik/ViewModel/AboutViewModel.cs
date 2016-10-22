using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.UI.Core;
using Windows.UI.Popups;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;

namespace SoonZik.ViewModel
{
    public class AboutViewModel : ViewModelBase
    {
        #region Ctor

        public AboutViewModel()
        {
            SendCommand = new RelayCommand(SendFeedBack);
            ItemList = new List<string> {"bug", "payment", "account", "other"};
            ItemChoose = "Selectionner une categorie";
        }

        #endregion

        private void SendFeedBack()
        {
            if (Email != null && ItemChoose != "Selectionner une categorie" && Object != null && Comment != null)
            {
                var post = new HttpRequestPost();
                var res = post.Feedback(Email, ItemChoose, Object, Comment);
                res.ContinueWith(delegate(Task<string> tmp2)
                {
                    var result = tmp2.Result;
                    if (result != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            AgileCallback);
                    }
                });
            }
            else
            {
                var loader = new ResourceLoader();
                new MessageDialog(loader.GetString("ErrorAbout")).ShowAsync();
            }
        }

        private void AgileCallback()
        {
            var loader = new ResourceLoader();
            new MessageDialog(loader.GetString("FeedbackSend")).ShowAsync();
        }

        #region Attribute

        public ICommand SendCommand { get; private set; }
        private string _email;

        public string Email
        {
            get { return _email; }
            set
            {
                _email = value;
                RaisePropertyChanged("Email");
            }
        }

        private string _username;

        public string Username
        {
            get { return _username; }
            set
            {
                _username = value;
                RaisePropertyChanged("Username");
            }
        }

        private string _object;

        public string Object
        {
            get { return _object; }
            set
            {
                _object = value;
                RaisePropertyChanged("Object");
            }
        }

        private string _comment;

        public string Comment
        {
            get { return _comment; }
            set
            {
                _comment = value;
                RaisePropertyChanged("Comment");
            }
        }

        private List<String> _itemList;

        public List<String> ItemList
        {
            get { return _itemList; }
            set
            {
                _itemList = value;
                RaisePropertyChanged("ItemList");
            }
        }

        private string _itemChoose;

        public string ItemChoose
        {
            get { return _itemChoose; }
            set
            {
                _itemChoose = value;
                RaisePropertyChanged("ItemChoose");
            }
        }

        #endregion

        #region Method

        #endregion
    }
}