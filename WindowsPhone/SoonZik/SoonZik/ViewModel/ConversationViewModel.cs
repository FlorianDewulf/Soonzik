using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.UI.Core;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;

namespace SoonZik.ViewModel
{
    public class ConversationViewModel : ViewModelBase
    {
        #region Ctor

        public ConversationViewModel()
        {
            SendCommand = new RelayCommand(SendCommandExecute);
            SelectionCommand = new RelayCommand(SelectionCommandExecute);
            loader = new ResourceLoader();
        }

        #endregion

        #region Attribute

        public ResourceLoader loader;
        public ICommand SendCommand { get; private set; }
        public ICommand SelectionCommand { get; private set; }

        private string _conversationText;

        public string ConversationText
        {
            get { return _conversationText; }
            set
            {
                _conversationText = value;
                RaisePropertyChanged("ConversationText");
            }
        }

        private ObservableCollection<Message> _listMessages;

        public ObservableCollection<Message> ListMessages
        {
            get { return _listMessages; }
            set
            {
                _listMessages = value;
                RaisePropertyChanged("ListMessages");
            }
        }

        private User _friendUser;

        public User FriendUser
        {
            get { return _friendUser; }
            set
            {
                _friendUser = value;
                RaisePropertyChanged("FriendUser");
            }
        }

        public static User NewUser { get; set; }

        #endregion

        #region Method

        private void SelectionCommandExecute()
        {
            MyNetworkViewModel.MeaagePrompt.Hide();
            FriendUser = NewUser;
            Charge();
        }

        private void SendCommandExecute()
        {
            var post = new HttpRequestPost();
            ValidateKey.GetValideKey();
            if (ConversationText != null)
            {
                var res = post.SaveMessage(ConversationText, FriendUser.id.ToString(),
                    Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser);
                res.ContinueWith(delegate(Task<string> tmp)
                {
                    var res2 = tmp.Result;
                    if (res2 != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            Charge);
                    }
                });
            }
        }

        private void Charge()
        {
            ConversationText = "";
            ListMessages = new ObservableCollection<Message>();
            var request = new HttpRequestGet();

            ValidateKey.GetValideKey();
            var resDel = request.GetConversation(FriendUser, Singleton.Singleton.Instance().SecureKey,
                Singleton.Singleton.Instance().CurrentUser, new List<Message>());
            resDel.ContinueWith(delegate(Task<object> tmp)
            {
                var test = tmp.Result as List<Message>;
                if (test != null)
                {
                    CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                        () =>
                        {
                            foreach (var message in test)
                            {
                                if (message.dest_id == Singleton.Singleton.Instance().CurrentUser.id)
                                {
                                    message.type = "recu";
                                    ListMessages.Add(message);
                                }
                                else
                                {
                                    message.type = "envoye";
                                    ListMessages.Add(message);
                                }
                            }
                        });
                }
            });
        }

        #endregion
    }
}