using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Globalization;
using System.Threading.Tasks;
using System.Windows.Input;
using Windows.ApplicationModel.Core;
using Windows.ApplicationModel.Resources;
using Windows.Data.Xml.Dom;
using Windows.Storage;
using Windows.Storage.Streams;
using Windows.UI.Core;
using Windows.UI.Notifications;
using Windows.UI.Popups;
using Windows.UI.Xaml;
using Coding4Fun.Toolkit.Controls;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Newtonsoft.Json;
using SoonZik.Controls;
using SoonZik.HttpRequest;
using SoonZik.HttpRequest.Poco;
using SoonZik.Utils;
using SoonZik.Views;

namespace SoonZik.ViewModel
{
    public class MyNetworkViewModel : ViewModelBase
    {
        #region Ctor

        public MyNetworkViewModel()
        {
            FollowerCommand = new RelayCommand(FollowerCommandExecute);
            TweetCommand = new RelayCommand(TweetCommandExecute);
            TappedCommand = new RelayCommand(Execute);
            LoadedCommand = new RelayCommand(UpdateFriend);
            SendTweet = new RelayCommand(SendTweetExecute);

            _conversation = new ObservableCollection<Message>();
            Sources = new ObservableCollection<User>();
            ItemSource = new ObservableCollection<AlphaKeyGroups<User>>();
            CurrentUser = Singleton.Singleton.Instance().CurrentUser;

            if (_localSettings != null && (string) _localSettings.Values["SoonZikAlreadyConnect"] == "yes")
            {
                Sources = Singleton.Singleton.Instance().CurrentUser.friends;
                ItemSource = AlphaKeyGroups<User>.CreateGroups(Sources, CultureInfo.CurrentUICulture, s => s.username,
                    true);
            }
            LoadTweet();
        }

        #endregion

        #region Method

        public static void LoadConversation()
        {
            try
            {
                ValidateKey.GetValideKey();
                var get = new HttpRequestGet();
                var res = get.FindConversation(new List<Message>(), Singleton.Singleton.Instance().SecureKey,
                    Singleton.Singleton.Instance().CurrentUser.id.ToString());
                res.ContinueWith(delegate(Task<object> tmp2)
                {
                    var result = tmp2.Result as List<Message>;
                    if (result != null)
                    {
                        _conversation = new ObservableCollection<Message>(result);
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            CheckConversation);
                    }
                });
            }
            catch (Exception)
            {
            }

        }

        private static async void AgileCallback()
        {
            // Serialize our Product class into a string             
            var jsonContents = JsonConvert.SerializeObject(_conversation);
            // Get the app data folder and create or replace the file we are storing the JSON in.            
            var localFolder = ApplicationData.Current.LocalFolder;
            var textFile = await localFolder.CreateFileAsync("conversations",
                CreationCollisionOption.ReplaceExisting);
            // Open the file...      
            using (var textStream = await textFile.OpenAsync(FileAccessMode.ReadWrite))
            {
                // write the JSON string!
                using (var textWriter = new DataWriter(textStream))
                {
                    textWriter.WriteString(jsonContents);
                    await textWriter.StoreAsync();
                }
            }
        }


        private static async void CheckConversation()
        {
            var localFolder = ApplicationData.Current.LocalFolder;
            try
            {
                // Getting JSON from file if it exists, or file not found exception if it does not  
                var textFile = await localFolder.GetFileAsync("conversations");
                if (textFile == null)
                {
                    var localFolder2 = ApplicationData.Current.LocalFolder;
                    textFile = await localFolder2.CreateFileAsync("conversations",
                        CreationCollisionOption.ReplaceExisting);
                }
                using (IRandomAccessStream textStream = await textFile.OpenReadAsync())
                {
                    // Read text stream     
                    using (var textReader = new DataReader(textStream))
                    {
                        //get size                       
                        var textLength = (uint) textStream.Size;
                        await textReader.LoadAsync(textLength);
                        // read it                    
                        var jsonContents = textReader.ReadString(textLength);
                        // deserialize back to our product!  
                        var getConv = JsonConvert.DeserializeObject<ObservableCollection<Message>>(jsonContents);
                        if (getConv.Count == _conversation.Count)
                        {
                            return;
                        }
                        AgileCallback();
                        var newList = new ObservableCollection<Message>();
                        for (var i = getConv.Count; i < _conversation.Count; i++)
                        {
                            if (_conversation[i].user_id != Singleton.Singleton.Instance().CurrentUser.id)
                                newList.Add(_conversation[i]);
                        }
                        var req = new HttpRequestGet();
                        foreach (var message in newList)
                        {
                            var user = req.GetObject(new User(), "users", message.user_id.ToString());
                            user.ContinueWith(delegate(Task<object> task)
                            {
                                var res = task.Result as User;
                                if (res != null)
                                {
                                    var toastType = ToastTemplateType.ToastText02;
                                    var toastXml = ToastNotificationManager.GetTemplateContent(toastType);
                                    var toastTextElement = toastXml.GetElementsByTagName("text");
                                    toastTextElement[0].AppendChild(
                                        toastXml.CreateTextNode("New Message from " + res.username));
                                    var toastNode = toastXml.SelectSingleNode("/toast");
                                    ((XmlElement) toastNode).SetAttribute("duration", "long");
                                    var toast = new ToastNotification(toastXml);
                                    ToastNotificationManager.CreateToastNotifier().Show(toast);
                                }
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                var Text = "Exception: " + ex.Message;
            }
        }

        private void Execute()
        {
            MeaagePrompt = new MessagePrompt
            {
                IsAppBarVisible = true,
                VerticalAlignment = VerticalAlignment.Center,
                Body = new ButtonFriendPopUp(SelectedUser.id),
                Opacity = 0.6
            };
            MeaagePrompt.Show();
            MeaagePrompt.Unloaded += MeaagePromptOnUnloaded;
        }

        private void MeaagePromptOnUnloaded(object sender, RoutedEventArgs routedEventArgs)
        {
            UpdateFriend();
        }

        private void FollowerCommandExecute()
        {
            ProfilArtisteViewModel.TheUser = SelectedUser;
            GlobalMenuControl.SetChildren(new ProfilArtiste());
        }

        public void UpdateFriend()
        {
            Sources = Singleton.Singleton.Instance().CurrentUser.friends;
            ItemSource = AlphaKeyGroups<User>.CreateGroups(Sources, CultureInfo.CurrentUICulture, s => s.username, true);
            //LoadConversation();
        }

        private void TweetCommandExecute()
        {
        }

        private void SendTweetExecute()
        {
            var post = new HttpRequestPost();
            try
            {
                ValidateKey.GetValideKey();
                var test = post.SendTweet(TextTweet, CurrentUser, Singleton.Singleton.Instance().SecureKey);
                test.ContinueWith(delegate(Task<string> tmp)
                {
                    var res = tmp.Result;
                    if (res != null)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            LoadTweet);
                    }
                });
            }
            catch (Exception)
            {
                var loader = new ResourceLoader();
                new MessageDialog(loader.GetString("ErrorTweet")).ShowAsync();
            }
        }

        private void LoadTweet()
        {
            ListTweets = new ObservableCollection<Tweets>();
            var req = new HttpRequestGet();
            var listTweets = req.GetListObject(new List<Tweets>(), "tweets");
            listTweets.ContinueWith(delegate(Task<object> tmp)
            {
                var res = tmp.Result as List<Tweets>;
                if (res != null)
                {
                    foreach (var item in res)
                    {
                        CoreApplication.MainView.CoreWindow.Dispatcher.RunAsync(CoreDispatcherPriority.Normal,
                            () =>
                            {
                                ListTweets.Insert(0, item);
                                //ListTweets.Add(item);
                            });
                    }
                }
            });
        }

        #endregion

        #region Attribute

        public ICommand FollowerCommand { get; private set; }
        public ICommand TweetCommand { get; private set; }
        public ICommand LoadedCommand { get; private set; }
        public ICommand SendTweet { get; private set; }
        private readonly ApplicationDataContainer _localSettings = ApplicationData.Current.LocalSettings;
        public static MessagePrompt MeaagePrompt { get; set; }
        private ObservableCollection<User> _sources;

        public ObservableCollection<User> Sources
        {
            get { return _sources; }
            set
            {
                _sources = value;
                RaisePropertyChanged("Sources");
            }
        }

        private ObservableCollection<AlphaKeyGroups<User>> _itemSource;

        public ObservableCollection<AlphaKeyGroups<User>> ItemSource
        {
            get { return _itemSource; }
            set
            {
                _itemSource = value;
                RaisePropertyChanged("ItemSource");
            }
        }

        private static ObservableCollection<Message> _conversation;
        private ObservableCollection<Tweets> _listTweets;

        public ObservableCollection<Tweets> ListTweets
        {
            get { return _listTweets; }
            set
            {
                _listTweets = value;
                RaisePropertyChanged("ListTweets");
            }
        }

        public RelayCommand TappedCommand { get; private set; }
        private User _selectedUser;

        public User SelectedUser
        {
            get { return _selectedUser; }
            set
            {
                _selectedUser = value;
                RaisePropertyChanged("SelectedUser");
            }
        }

        private User _currentUser;

        public User CurrentUser
        {
            get { return _currentUser; }
            set
            {
                _currentUser = value;
                RaisePropertyChanged("CurrentUser");
            }
        }

        private Tweets _selectedTweet;

        public Tweets SelectedTweet
        {
            get { return _selectedTweet; }
            set
            {
                _selectedTweet = value;
                RaisePropertyChanged("SelectedTweet");
            }
        }

        private string _textTweet;

        public string TextTweet
        {
            get { return _textTweet; }
            set
            {
                _textTweet = value;
                RaisePropertyChanged("TextTweet");
            }
        }

        private string _crypto;

        #endregion
    }
}